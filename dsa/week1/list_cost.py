import time


def append_to_end(n):
    start = time.perf_counter()
    alist = []
    for i in range(n):
        alist.append(i)
    end = time.perf_counter()
    print(f"append:    {end - start:.4f} s")


def insert_at_beginning(n):
    start = time.perf_counter()
    ilist = []
    for i in range(n):
        ilist.insert(0, i)
    end = time.perf_counter()
    print(f"insert(0): {end - start:.4f} s")


append_to_end(200000)
insert_at_beginning(200000)


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# What this file proves: WHERE you add to a Python list changes the cost.
#
#   append(x)     -> goes on the end, nothing moves        -> O(1) each
#   insert(0, x)  -> every existing item shifts right by 1 -> O(n) each
#
# So doing it n times:
#   n appends     -> O(n) total
#   n insert(0)s  -> O(n^2) total (that's why the second timing is far slower)
#
# time.perf_counter() before and after = how long the block took.
#
# Takeaway: add/remove at the END of a list. Need the front too? -> collections.deque.
# This is why a stack uses the end of the list as its top (week5/stack.py).
