# OOP 03 — Inheritance

## TL;DR
- Inheritance = a child class gets everything from a parent class, then adds or changes things. `class SavingsAccount(Account):`
- Test for whether it fits: **"is-a"**. A savings account *is an* account.
- `super().__init__(...)` runs the parent's setup, so shared code isn't copied into every child. Forget it and the parent's attributes never get set.
- **Overriding:** the child defines a method with the same name as the parent's, and the child's version wins.
- `isinstance(obj, Account)` is `True` for subclass objects too.
- **Composition ("has-a")** is the alternative: an account *has* a list of transactions, but it *isn't* a transaction.
- **Polymorphism:** one call, `acc.withdraw(100)`, behaves differently depending on the object's class.

Sources: [Python docs: Inheritance (tutorial 9.5)](https://docs.python.org/3/tutorial/classes.html#inheritance), [Real Python: Inheritance and Composition](https://realpython.com/inheritance-composition-python/)

## What is it?
- **Inheritance:** `class SavingsAccount(Account)` means `SavingsAccount` starts with every attribute and method `Account` has. `Account` is the **parent** (base class, superclass). `SavingsAccount` is the **child** (subclass).
- **"Is-a" relationship:** inheritance only makes sense when the child really is a kind of the parent. Savings account → account: yes. Transaction → account: no.
- **`super().__init__(...)`:** calls the parent's `__init__` from inside the child's `__init__`. The parent sets up the shared attributes (`owner`, `balance`, `transactions`), then the child adds its own (`interest_rate`).
- **Overriding:** if the child defines `withdraw()` and so does the parent, calling `withdraw()` on a child object runs the child's version. Python looks in the object's own class first, then in the parent.
- **`isinstance`:** `isinstance(savings, Account)` is `True`, because a savings account is an account. `isinstance(savings, CurrentAccount)` is `False`, because they're siblings, not parent and child.
- **Composition:** instead of inheriting from a class, hold an object of it as an attribute. `self.transactions = []` is composition: the account *has* transactions.
- **Polymorphism:** different classes have a method with the same name, so the same line of code works on any of them and each does its own thing.

## Why does it exist?
- Savings and current accounts share most of their code: an owner, a balance, a history, deposit, withdraw. Without inheritance I'd copy all of it into both classes, and a bug fix would have to be made twice.
- With inheritance the shared part lives once, in `Account`. Each child only writes what is **different** about it.
- Code that works on accounts doesn't have to care which kind it gets. A loop can call `acc.withdraw(100)` on a mix of savings and current accounts (polymorphism).
- Inheritance is the wrong tool when the relationship isn't "is-a". Making `Account` inherit from `list` just to store transactions would give it `.sort()`, `.pop()` and dozens of other methods that make no sense on an account. Holding a list as an attribute (composition) is cleaner.

## An example
My account classes ([oop_accounts.py](oop_accounts.py), trimmed here):

```python
class Account:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance
        self.transactions = []          # composition: an account HAS transactions

    def deposit(self, amount):
        self.balance += amount
        self.transactions.append(amount)

    def withdraw(self, amount):
        if amount > self.balance:
            raise ValueError("insufficient funds")
        self.balance -= amount
        self.transactions.append(-amount)


class SavingsAccount(Account):          # inheritance: a savings account IS an account
    def __init__(self, owner, balance=0, interest_rate=0.03):
        super().__init__(owner, balance)    # parent sets owner, balance, transactions
        self.interest_rate = interest_rate  # child adds its own

    def add_interest(self):             # new method, only on savings
        self.deposit(self.balance * self.interest_rate)


class CurrentAccount(Account):
    def __init__(self, owner, balance=0, overdraft=1000):
        super().__init__(owner, balance)
        self.overdraft = overdraft

    def withdraw(self, amount):         # override: allows going below 0
        if amount > self.balance + self.overdraft:
            raise ValueError("over overdraft limit")
        self.balance -= amount
        self.transactions.append(-amount)


s = SavingsAccount("Arsh", 500)
c = CurrentAccount("Arsh", 500)

s.add_interest()      # s.balance -> 515.0
c.withdraw(800)       # c.balance -> -300 (overdraft)
s.withdraw(800)       # ValueError: insufficient funds (parent's withdraw)

isinstance(s, Account)          # True
isinstance(s, CurrentAccount)   # False
```

- `SavingsAccount` never defines `deposit` or `withdraw`, but has both from `Account`.
- `CurrentAccount` overrides `withdraw`, so the same call `withdraw(800)` succeeds on `c` and fails on `s`. That's polymorphism.
- **What breaks without `super().__init__()`:** if `SavingsAccount.__init__` only set `self.interest_rate`, then `self.balance` and `self.transactions` would never exist. Nothing fails at creation. The error comes later, on the first `s.deposit(...)`: `AttributeError: 'SavingsAccount' object has no attribute 'balance'`.

## An interview question
**Q:** What is inheritance? Give a finance example.

**A:** Inheritance lets a child class reuse everything from a parent class and then add or change things. For example, `SavingsAccount(Account)` gets owner, balance, deposit and withdraw from `Account` for free, and only adds what's specific to it, like an interest rate and `add_interest()`. It fits because a savings account *is an* account.

**Q:** What does `super().__init__()` do, and what breaks if you forget it?

**A:** It runs the parent class's `__init__`, so the parent's attributes get set up without copying that code into the child. If you forget it, the child's own `__init__` replaces the parent's completely, so attributes like `balance` are never created. The object is built without error, but you get an `AttributeError` later, the first time any method touches `self.balance`.

**Q:** What's method overriding?

**A:** It's when a child class defines a method with the same name as one in the parent. Calls on a child object use the child's version. In my example `CurrentAccount` overrides `withdraw()` to allow an overdraft, while `SavingsAccount` keeps the parent's version that refuses to go below zero.

**Q:** Inheritance vs composition: when would you use each?

**A:** Use inheritance for an "is-a" relationship, and composition for "has-a". A savings account *is an* account, so it inherits. An account *has* transactions but *isn't* a transaction, so it holds them in an attribute (`self.transactions`). If unsure, prefer composition: it's looser, it doesn't drag in methods you don't want, and you can swap the inner object without changing the class hierarchy.

**Q:** What's polymorphism, in one sentence with an example?

**A:** Polymorphism means the same method call behaves differently depending on the object's class: `acc.withdraw(800)` refuses on a `SavingsAccount` with 500 AED but succeeds on a `CurrentAccount` because of its overdraft, and the calling code doesn't need to know which one it has.
