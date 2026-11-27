# OS 04 — Concurrency: race conditions, locks and deadlock

## TL;DR
- **Race condition** = the result depends on the timing of the threads, so the same code gives different answers on different runs.
- **Critical section** = code that touches shared data and must not run in two threads at once.
- **Lock** = only one thread at a time can hold it, so only one thread at a time is inside the critical section (**mutual exclusion**).
- **Deadlock** = threads each hold a lock and wait for a lock another one holds, so none of them can ever continue.
- **Lock ordering** = every thread takes locks in the same order. Then nobody can wait in a circle, and deadlock can't happen.
- In the project, PostgreSQL does this work for us: each statement is a transaction, rows are locked while being changed, and `SERIAL` ids come from a sequence that never hands out the same number twice.

Sources: [OSTEP ch 28: Locks](https://pages.cs.wisc.edu/~remzi/OSTEP/threads-locks.pdf) · [OSTEP ch 32: Common Concurrency Problems](https://pages.cs.wisc.edu/~remzi/OSTEP/threads-bugs.pdf) · code: [race.py](race.py), [deadlock.py](deadlock.py)

## What is it?

### Race condition
- A **race condition** happens when two threads use the same data at the same time, and the final result depends on which one happens to run first.
- The classic case is **read → change → write** (`counter = counter + 1`). It looks like one step, but it's three. If another thread runs between the read and the write, one of the updates is lost.

### Critical section and locks
- A **critical section** is the piece of code that reads or writes shared data. In `race.py` it's the 3 lines `tmp = counter` / `time.sleep(0)` / `counter = tmp + 1`.
- A **lock** (also called a **mutex**) is a guard around the critical section:
  - `lock.acquire()` (or `with lock:`): if the lock is free, take it and go in. If another thread holds it, wait.
  - `lock.release()` (automatic at the end of `with`): give it back so a waiting thread can go in.
- **What a lock guarantees:** at most one thread is inside the critical section at any moment, so the read-change-write happens as one unit (**atomically**) as far as other threads are concerned.
- **What it does not guarantee:** which waiting thread goes next (fairness), or that you used it everywhere. A lock only protects code that actually takes it.
- How locks work underneath (OSTEP ch 28): a plain `if not locked: locked = True` doesn't work, because two threads can both pass the `if` before either sets the flag. That check is a race condition itself. Real locks rely on a special CPU instruction that tests and sets in one step that can't be interrupted (**test-and-set**, **compare-and-swap**). A waiting thread either keeps checking in a loop (**spin lock**) or is put to sleep by the OS until the lock is free.

### Deadlock
- A **deadlock** is when two or more threads each hold a lock and wait for a lock that another one holds, so all of them wait forever.
- OSTEP lists **4 conditions**. All 4 must be true for a deadlock:
  1. **Mutual exclusion:** a lock can only be held by one thread.
  2. **Hold-and-wait:** a thread keeps the locks it has while waiting for more.
  3. **No preemption:** you can't take a lock away from the thread holding it.
  4. **Circular wait:** there's a cycle: T1 waits for T2, and T2 waits for T1.
- Break any one of them and deadlock is impossible. The practical one to break is **circular wait**, using **lock ordering**.

## Why does it exist?
- Threads share memory. That's what makes them useful (no copying data between them), and it's also why they can step on each other.
- The OS scheduler can switch threads **at any instruction**, and you can't control when. So any code that is correct "only if nobody interrupts" is a bug waiting to happen. Usually it works, and it fails rarely and randomly, which makes these bugs hard to find.
- Locks fix races, but bring a new problem: as soon as a thread needs **two** locks, the order it takes them in matters. That's where deadlock comes from.
- OSTEP cites a study of real bugs in big programs (MySQL, Apache, Mozilla, OpenOffice): most concurrency bugs were **not** deadlocks. They were races, either code that should have been atomic and wasn't, or code that assumed another thread had already done something.

## An example

### Q1: What is a race condition? (race.py)
A race condition is when the result depends on how the threads happen to be scheduled, so a shared value comes out wrong.

[race.py](race.py) runs `work()` in 2 threads, and each adds 1 to `counter` 1000 times, so it should print **2000**. It prints **about 1000**, because each `+1` is split into read, sleep, write, and `time.sleep(0)` hands control to the other thread **between the read and the write**:

| Step | Thread 1 | Thread 2 | counter |
|---|---|---|---|
| 1 | `tmp = counter` → 0 | | 0 |
| 2 | `sleep(0)` → switch | `tmp = counter` → 0 | 0 |
| 3 | `counter = 0 + 1` | | 1 |
| 4 | | `counter = 0 + 1` | **1** (should be 2) |

Both threads read the same old value, so one of the two writes is thrown away. Since `sleep(0)` makes them take turns almost every time, nearly every pair of increments loses one, which is why the total ends up near 1000 instead of 2000.

### Q2: What is a critical section, and what does a lock guarantee?
The critical section in `race.py` is the read-sleep-write of `counter`. Wrapping it in a lock fixes the program:

```python
lock = threading.Lock()

def work():
    global counter
    for _ in range(1000):
        with lock:               # only one thread at a time past this line
            tmp = counter
            time.sleep(0)
            counter = tmp + 1
```

Now when thread 1 sleeps inside the block, thread 2 reaches `with lock:` and **waits**, because the lock is held. It can't read `counter` until thread 1 has written its new value and released the lock. The result is **2000** on every run.

The lock guarantees **mutual exclusion**: at most one thread inside the block at a time, so read-change-write behaves as one step.

### Q3: What is a deadlock? (deadlock.py)
A deadlock is when threads each hold a lock and wait for a lock another thread holds, so none of them can ever continue.

In [deadlock.py](deadlock.py):

| Thread | Takes first | Then `sleep(0.1)` | Waits for | Held by |
|---|---|---|---|---|
| `one()` | lock `a` | still holding `a` | lock `b` | `two()` |
| `two()` | lock `b` | still holding `b` | lock `a` | `one()` |

The `sleep(0.1)` makes sure both threads grab their first lock before either tries for its second. Then each is waiting for the other, forever. Neither `"done"` line prints, and the script ends with `still stuck: True True`. (`daemon=True` and `join(timeout=2)` are only there so the script can exit at all.)

All 4 conditions are true here: a lock has one owner, each thread holds one lock while waiting, Python can't take a lock away, and `one` waits on `two` while `two` waits on `one` (a circle).

### Q4: The one-line fix, and the rule behind it
Make `two()` take the locks in the **same order** as `one()`, `a` first and then `b`:

```python
def two():
    with a:              # same order as one()
        time.sleep(0.1)
        with b:
            print("two done")
```

Now whichever thread gets `a` first also gets `b`, and the other thread waits at `a` while holding **nothing**. There's no circle, so both threads finish: `one done`, `two done`, `still stuck: False False`.

This is OSTEP's **lock ordering**: decide one global order for all locks, and every thread acquires them in that order. It breaks the **circular wait** condition. For a cycle, someone would have to hold a later lock while waiting for an earlier one, and the rule never allows that. (OSTEP's trick when the locks are passed in as arguments: always take the one with the lower memory address first.)

### Q5: Link to the project, two API requests insert at the same moment
uvicorn can handle several requests at once, so two `POST /transactions` could run at the same time, just like the two threads in `race.py`. PostgreSQL stops them from making the same mess:

- **Each statement is a transaction** ([ACID](dbms-04-acid.md)). An `INSERT` happens completely or not at all (**atomicity**), and the other request never sees a half-written row (**isolation**).
- **New ids can't clash.** `id SERIAL` takes its value from a **sequence**, and handing out the next number is atomic inside Postgres: one request gets 41, the other gets 42, never both 41. This is the `counter += 1` from `race.py`, done safely.
- **Rows are locked while they change.** If two requests `UPDATE` the same row, the second waits until the first commits, like `with lock:`.
- **Durability:** once `COMMIT` returns, the row survives a crash.

One way to still recreate `race.py` with a database: `SELECT` a value into Python, change it in Python, then `UPDATE` with the new number. That's read → change → write split across two statements, so two requests can both read the old value. The fixes are to do the math in SQL (`UPDATE ... SET x = x + 1`, one statement, so one locked step) or to lock the row when reading it (`SELECT ... FOR UPDATE`).

Postgres can also deadlock (two transactions locking the same two rows in opposite orders). It **detects** the cycle and cancels one of them with `ERROR: deadlock detected`. That's OSTEP's "detect and recover" approach, instead of prevention.

## An interview question
**Q:** What's a race condition, and how do you fix one?

**A:** It's when two threads use shared data at the same time and the result depends on the timing. The usual case is `x = x + 1`, which is really read, add, write: if both threads read before either writes, one update is lost. You fix it by making the read-change-write a critical section protected by a lock, so only one thread can be inside it at a time.

**Q:** What's a deadlock, and how do you prevent it?

**A:** Two or more threads each hold a lock and wait for one another holds, so they all wait forever. It needs four conditions: mutual exclusion, hold-and-wait, no preemption, and circular wait. The usual prevention is lock ordering: every thread acquires locks in the same global order, which makes a circular wait impossible.

**Q:** Two API requests write to the database at the same moment. Why don't they corrupt each other?

**A:** Each statement runs as a transaction, so it's atomic and isolated. Rows are locked while they're being changed, and auto-increment ids come from a sequence that never returns the same number twice. The danger is reading a value into the application, changing it there and writing it back. That should be one `UPDATE` with the math in SQL, or a `SELECT ... FOR UPDATE`.
