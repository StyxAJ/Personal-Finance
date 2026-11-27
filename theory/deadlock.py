import threading, time

a = threading.Lock()
b = threading.Lock()

def one():
    with a:
        time.sleep(0.1)
        with b:
            print("one done")

def two():
    with a:              # opposite order to one()
        time.sleep(0.1)
        with b:
            print("two done")

t1 = threading.Thread(target=one, daemon=True)
t2 = threading.Thread(target=two, daemon=True)
t1.start(); t2.start()
t1.join(timeout=2); t2.join(timeout=2)
print("still stuck:", t1.is_alive(), t2.is_alive())