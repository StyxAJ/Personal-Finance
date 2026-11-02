class Stack:
    def __init__(self):
        # make an empty list and store it on self
        self.items = []

    def push(self, item):
        self.items.append(item)

    def pop(self):
        if self.is_empty():
            raise IndexError("pop from empty stack")
        return self.items.pop()

    def peek(self):
        if self.is_empty():
            raise IndexError("peek from empty stack")
        return self.items[-1]

    def is_empty(self):
        return len(self.items) == 0


my_stack = Stack()

# 1. push 1-5, then peek -> 5
for i in range(1, 6):
    my_stack.push(i)
print("peek:", my_stack.peek())

# 2. pop 5 times -> 5, 4, 3, 2, 1
for i in range(5):
    print("pop:", my_stack.pop())

# 3. is_empty -> True
print("is_empty:", my_stack.is_empty())

# 4. pop on empty -> my own IndexError message
try:
    my_stack.pop()
except IndexError as e:
    print("error:", e)


# Logic

# | Step | Operation  | List after | Returned |
# |------|------------|------------|----------|
# | 1    | push(1)    | [1]        | –        |
# | 2    | push(2)    | [1,2]      | –        |
# | 3    | push(3)    | [1,2,3]    | –        |
# | 4    | peek()     | [1,2,3]    | 3        |
# | 5    | pop()      | [1,2]      | 3        |
# | 6    | pop()      | [1]        | 2        |
# | 7    | is_empty() | [1]        | False    |

# ---------------------------------------------------------------
# What a stack is
# ---------------------------------------------------------------
# Stack = LIFO (last in, first out), like a pile of plates.
# I store the items in a Python list. The TOP is the END of the list.
#
# Why the end and not the start?
#   append / pop() at the end -> nothing shifts      -> O(1)
#   insert(0, x) / pop(0)     -> every item shifts   -> O(n)
#   (proved in week1/list_costs.py)
#
# Big-O (top = end of list):
#   push     O(1)
#   pop      O(1)
#   peek     O(1)
#   is_empty O(1)
#
# Edge case: pop() or peek() on an empty stack
#   -> raise IndexError with my own message (same as list.pop()).
#
# ---------------------------------------------------------------
# Plain-English steps (code goes under each one)
# ---------------------------------------------------------------
# __init__ : make an empty list and store it on self.
# push     : add the item to the end of the list.
# pop      : if empty -> raise IndexError("...")
#            else     -> remove the last item and return it.
# peek     : if empty -> raise IndexError("...")
#            else     -> return the last item WITHOUT removing it.
# is_empty : return True if the list has no items, else False.
#
# ---------------------------------------------------------------
# Tests (at the bottom of the file)
# ---------------------------------------------------------------
# 1. push 1, 2, 3, 4, 5      -> peek() gives 5
# 2. pop 5 times             -> 5, 4, 3, 2, 1
# 3. is_empty()              -> True
# 4. pop() on empty stack    -> caught by try/except IndexError
# Rule: tests use only the methods, never the list directly.
