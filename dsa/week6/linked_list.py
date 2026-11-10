class Node:
    def __init__(self, value):
        # one box: the value it holds, and an arrow to the next box
        self.value = value
        self.next = None


class LinkedList:
    def __init__(self):
        # empty list: head points at nothing
        self.head = None

    def append(self, value):
        new_node = Node(value)
        if self.head is None:
            self.head = new_node
            return
        current = self.head
        while current.next is not None:
            current = current.next
        current.next = new_node

    def prepend(self, value):
        new_node = Node(value)
        new_node.next = self.head
        self.head = new_node

    def to_list(self):
        values = []
        current = self.head
        while current is not None:
            values.append(current.value)
            current = current.next
        return values

    def length(self):
        count = 0
        current = self.head
        while current is not None:
            count += 1
            current = current.next
        return count


my_list = LinkedList()

# 1. empty list -> [] and length 0
print("empty:", my_list.to_list(), my_list.length())

# 2. append 1, 2, 3 -> [1, 2, 3]
for i in range(1, 4):
    my_list.append(i)
    print("after append", i, ":", my_list.to_list())

# 3. prepend 0 -> [0, 1, 2, 3]
my_list.prepend(0)
print("after prepend 0:", my_list.to_list())

# 4. length -> 4
print("length:", my_list.length())

# 5. prepend on an empty list -> [9]
other = LinkedList()
other.prepend(9)
print("prepend on empty:", other.to_list())


# ---------------------------------------------------------------
# Boxes and arrows
# ---------------------------------------------------------------
# Start empty:
#   head -> None
#
# append(1):
#   head -> [1] -> None
#
# append(2):
#   head -> [1] -> [2] -> None
#
# append(3):
#   head -> [1] -> [2] -> [3] -> None
#
# prepend(0):
#   head -> [0] -> [1] -> [2] -> [3] -> None
#   (new box points at the old head, then head moves to the new box)
#
# ---------------------------------------------------------------
# Answers
# ---------------------------------------------------------------
# How do you find the last node?
#   Start at head and keep following .next.
#   You've reached the last node when its .next is None.
#   (Empty list is a special case: head itself is None,
#    so the new node just becomes head.)
#
# Big-O:
#   append   O(n) -> must walk every node to find the end
#   prepend  O(1) -> only touch head, no matter how long the list is
#   to_list  O(n)
#   length   O(n) -> walks the whole chain (could be O(1) with a counter)
#
# Compared with a Python list:
#   Python list: insert(0, x) is O(n) (every item shifts right),
#                append(x) is O(1).
#   Linked list: prepend is O(1) (no shifting, just move one arrow),
#                append is O(n) (no tail pointer, so walk to the end).
#   -> Adding at the FRONT is the cheap one here; it was expensive there.
