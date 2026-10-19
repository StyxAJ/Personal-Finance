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
