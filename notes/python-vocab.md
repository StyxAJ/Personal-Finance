# Python for DSA: English → Python

When I know the idea but not the syntax, look it up here. The left column is how I'd say it out loud; the right is how Python says it.

---

## 1. Classes and objects

| In English | In Python |
|---|---|
| a class with its own data | `class Node:` → `def __init__(self, value):` → `self.value = value` |
| make a new object | `Node(5)`, `LinkedList()`, `Stack()` |
| this object's own variable | `self.head`, `self.items` |
| a method (a function that belongs to the class) | `def push(self, x):` (first parameter is always `self`) |
| call a method on an object | `my_list.append(3)` (Python fills in `self` for you) |
| class names | CamelCase: `Node`, `LinkedList`, `MinStack` |
| function and variable names | snake_case: `to_list`, `new_node`, `max_profit` |

**Indentation rule:** `class` at 0 spaces, every `def` inside it at 4, every line inside a `def` at 8. Mixed levels give `IndentationError` with a line number, so start looking at that line.

---

## 2. Linked list

| In English | In Python |
|---|---|
| a class with its own data | `class Node:` → `def __init__(self, value):` → `self.value = value` |
| make a new box holding 5 | `Node(5)` |
| a box's value / its arrow | `node.value` / `node.next` |
| "points at nothing" | `None` |
| the list's first box | `self.head` |
| is the list empty? | `self.head is None` |
| point box A at box B | `a.next = b` |
| make the head be this box | `self.head = new_node` |
| start walking from the front | `current = self.head` |
| keep going until the end | `while current is not None:` |
| stop ON the last box (not past it) | `while current.next is not None:` |
| step to the next box | `current = current.next` |
| save an arrow before overwriting it | `saved = current.next` |
| add to a Python list | `values.append(x)` |

**Rule:** never overwrite the only arrow to something you still need. Save it first.

| Operation | Cost | Why |
|---|---|---|
| prepend | O(1) | only touches `head` |
| append (no tail pointer) | O(n) | has to walk to the end |
| to_list / length | O(n) | visits every box |

---

## 3. Python list (array)

| In English | In Python | Cost |
|---|---|---|
| empty list | `nums = []` | O(1) |
| add to the end | `nums.append(x)` | O(1) |
| remove from the end | `nums.pop()` | O(1) |
| add at the front | `nums.insert(0, x)` | **O(n)**, everything shifts right |
| remove from the front | `nums.pop(0)` | **O(n)**, everything shifts left |
| read / change one item | `nums[i]`, `nums[i] = x` | O(1) |
| last item | `nums[-1]` | O(1) |
| how many items | `len(nums)` | O(1) |
| is x in the list? | `x in nums` | **O(n)**, checks one by one |
| copy part of it | `nums[a:b]` | O(b − a), slicing makes a copy |
| a list of n zeros | `[0] * n` | O(n) |
| sort it | `nums.sort()` / `sorted(nums)` | O(n log n) |
| reverse it | `nums.reverse()` / `nums[::-1]` | O(n) |

---

## 4. Loops

| In English | In Python |
|---|---|
| go through every item | `for x in nums:` |
| go through every index | `for i in range(len(nums)):` |
| index and item together | `for i, x in enumerate(nums):` |
| count from a to b−1 | `for i in range(a, b):` |
| count backwards | `for i in range(len(nums) - 1, -1, -1):` |
| two lists side by side | `for a, b in zip(list1, list2):` |
| loop while a condition holds | `while left < right:` |
| skip to the next round | `continue` |
| leave the loop now | `break` |

---

## 5. Two pointers

| In English | In Python |
|---|---|
| one pointer at each end | `left, right = 0, len(nums) - 1` |
| until they meet | `while left < right:` |
| until they cross (middle still counts) | `while left <= right:` |
| move inward | `left += 1` / `right -= 1` |
| swap two items | `nums[left], nums[right] = nums[right], nums[left]` |
| slow/fast, same direction | `write` marks the last kept slot, `read` scans everything |

---

## 6. Hash set and hash map

| In English | In Python | Cost |
|---|---|---|
| empty set | `seen = set()` (not `{}`, which makes a dict) | O(1) |
| have I seen this? | `x in seen` | O(1) |
| remember it | `seen.add(x)` | O(1) |
| empty dict | `counts = {}` | O(1) |
| look up, with a default if missing | `counts.get(ch, 0)` | O(1) |
| count something | `counts[ch] = counts.get(ch, 0) + 1` | O(1) |
| is this key there? | `key in counts` | O(1) |
| remember value → index | `seen[x] = i` | O(1) |
| loop over keys / pairs | `for k in d:` / `for k, v in d.items():` | O(n) |

**Rule:** a "have I seen it before?" question usually needs a set. If you also need where you saw it or how many times, use a dict.

Shortcuts worth knowing later: `from collections import Counter` (`Counter(s)` counts everything in one line) and `defaultdict(int)` (missing keys start at 0).

---

## 7. Running totals, prefix sums, sliding window

| In English | In Python |
|---|---|
| keep a running total | `total += x` |
| sum of everything | `sum(nums)` (O(n), so call it once, not inside a loop) |
| best so far | `best = max(best, current)` |
| smallest so far | `low = min(low, x)` |
| "nothing yet" for a max / min | `float('-inf')` / `float('inf')` |
| fixed window of size k: slide by one | `window += nums[i] - nums[i - k]` |
| left side vs right side of an index | start `right = total`, then each step: `right -= x`, compare, `left += x` |

---

## 8. Stack

| In English | In Python | Cost |
|---|---|---|
| empty stack | `stack = []` | O(1) |
| push | `stack.append(x)` | O(1) |
| pop the top | `stack.pop()` | O(1) |
| peek at the top | `stack[-1]` | O(1) |
| is it empty? | `not stack` / `len(stack) == 0` | O(1) |

**Rule:** check for empty **before** `pop()` or `stack[-1]`. On an empty list both raise `IndexError`.

The top is the end of the list because that end is O(1). The front would be O(n).

---

## 9. Queue (coming up)

A Python list is a bad queue because `pop(0)` is O(n). Use `deque`:

| In English | In Python | Cost |
|---|---|---|
| empty queue | `from collections import deque` → `q = deque()` | O(1) |
| join the back | `q.append(x)` | O(1) |
| leave from the front | `q.popleft()` | O(1) |

---

## 10. Comparisons and checks

| In English | In Python |
|---|---|
| is it nothing? | `x is None` (use `is`, not `==`, for `None`) |
| is it something? | `x is not None` |
| same value | `a == b` |
| is the character a letter or digit? | `ch.isalnum()` |
| lowercase it | `ch.lower()` |
| whole number division | `7 // 2` → `3` |
| remainder | `7 % 2` → `1` |

**Rule:** `while current:` and `while current is not None:` behave differently when a value can be `0` or empty. Write the explicit version.

---

## 11. Reading error messages

| Error | Usually means |
|---|---|
| `IndentationError` | levels don't line up: check the `def`s in a class are all at the same level |
| `IndexError: list index out of range` | `nums[i]` with i too big, or `pop()` / `[-1]` on an empty list |
| `AttributeError: 'NoneType' object has no attribute 'next'` | you did `current.next` while `current` was `None`: the loop walked off the end |
| `KeyError` | `d[key]` for a missing key: use `d.get(key, 0)` or check `key in d` first |
| `TypeError: ... missing 1 required positional argument` | forgot `self` in a method, or called it with the wrong number of arguments |
| `NameError` | typo in a name, or using a variable before it exists |

Read the **last line** of the error first, then go to the line number it names.
