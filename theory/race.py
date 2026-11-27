import threading, time

counter = 0

def work():
    global counter
    for _ in range(1000):
        tmp = counter        # 1. read
        time.sleep(0)        # 2. let the other thread run
        counter = tmp + 1    # 3. write

t1 = threading.Thread(target=work)
t2 = threading.Thread(target=work)
t1.start(); t2.start()
t1.join(); t2.join()
print(counter)