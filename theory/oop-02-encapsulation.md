# OOP 02 — Encapsulation

## TL;DR
- Encapsulation = an object's data **and the rules about that data** live inside the object, so outside code can't put it into a bad state.
- `_amount` (one underscore) = "internal, don't touch from outside". Python doesn't block it. It's a promise between programmers.
- `__amount` (two underscores) triggers **name mangling**: Python renames it to `_Transaction__amount`. Know it exists, don't need it yet.
- `@property` makes `t.amount` look like a plain attribute while running a method behind it.
- `@amount.setter` runs on every `t.amount = x`, so that's where validation goes.
- Trap: `__init__` must assign through the setter (`self.amount = amount`), not `self._amount = amount`, or the check is skipped on creation.

Sources: [Python docs: Private variables (tutorial 9.6)](https://docs.python.org/3/tutorial/classes.html#private-variables), [Python docs: property](https://docs.python.org/3/library/functions.html#property)

## What is it?
- **Encapsulation** means bundling data with the code that guards it. The object decides what counts as a valid value, not the code using it.
- **Private by convention:** a leading underscore (`_amount`) marks an attribute as internal. Anyone *can* write `t._amount = 0`, but the underscore says "if you do, it's on you".
- **Name mangling:** `self.__amount` inside class `Transaction` is stored as `self._Transaction__amount`. It's meant to stop a *subclass* from accidentally overwriting a parent's attribute with the same name. It is not real privacy, because you can still reach `t._Transaction__amount`.
- **`@property`:** turns a method into something you read like an attribute. `t.amount` (no brackets) calls the `amount` method and returns its result.
- **`@amount.setter`:** the matching method that runs when you assign. `t.amount = -50` calls it with `value = -50`.
- The real value is stored in `_amount`. The property `amount` is the public door to it.

## Why does it exist?
- Without it, any line of code anywhere can do `t.amount = 0`. A transaction of 0 AED makes no sense, and nothing would stop it. The bug shows up later, far from where it happened.
- With a setter, the rule ("amount can't be 0") lives in **one place**. Every way of setting the amount goes through it, so a bad value is refused at the moment it's set.
- Why a property and not a `set_amount()` method?
  - Callers keep the simple `t.amount = x` syntax.
  - I can start with a plain attribute and add validation later **without changing any code that uses the class**. If I'd switched to `set_amount()`, every `t.amount = x` in the project would have to be rewritten.

## An example
My `Transaction` class ([oop_transaction.py](oop_transaction.py)):

```python
class Transaction:
    def __init__(self, amount, txn_date, category):
        self.amount = amount          # goes through the setter, so it's checked
        self.date = txn_date
        self.category = category

    @property
    def amount(self):
        return self._amount

    @amount.setter
    def amount(self, value):
        if value == 0:
            raise ValueError("amount cannot be 0")
        self._amount = value


t = Transaction(-50.00, date(2026, 11, 3), "Transport")
t.amount = 0        # ValueError: amount cannot be 0
print(t.amount)     # -50.0, the old value is kept

Transaction(0, date(2026, 11, 4), "Misc")   # ValueError on creation too
```

- `t.amount` reads through the property, which returns `self._amount`.
- `t.amount = 0` calls the setter, which raises before `_amount` is changed, so the object stays valid.
- **The trap I hit:** if `__init__` said `self._amount = amount`, it would write straight to the storage and skip the setter. `Transaction(0, ...)` would then be created without any error. Writing `self.amount = amount` in `__init__` means creation and later changes both go through the same check.

## An interview question
**Q:** What is encapsulation, and why does it matter?

**A:** Encapsulation is keeping an object's data and the rules about that data inside the object, so outside code can't put it into an invalid state. In my `Transaction` class, an amount of 0 is meaningless. Instead of hoping every caller remembers that, the `amount` setter raises a `ValueError` on 0. The rule lives in one place and applies whether the transaction is being created or edited later.

**Q:** What's the difference between `amount` and `_amount` in your class?

**A:** `_amount` is where the value is actually stored. The underscore marks it as internal. `amount` is a property: the public way to read and write it. Reading `t.amount` returns `_amount`, and writing `t.amount = x` runs the setter, which validates `x` before saving it to `_amount`.

**Q:** Why use a property instead of a `set_amount()` method?

**A:** Callers keep the natural `t.amount = x` syntax, and I can add validation later without changing their code. If `amount` started as a plain attribute, I can turn it into a property and every existing `t.amount = x` keeps working, now with the check. With a `set_amount()` method I'd have to find and rewrite every assignment.

**Q:** Does Python have truly private attributes?

**A:** No. A single underscore is only a convention that says "internal, don't touch". A double underscore triggers name mangling, which renames `__amount` to `_Transaction__amount`. That avoids name clashes in subclasses, but you can still access it if you use the mangled name. Python trusts programmers to respect the convention.
