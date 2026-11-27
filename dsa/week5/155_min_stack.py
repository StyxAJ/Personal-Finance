class MinStack:
    def __init__(self):
        self.min_stack = []
        self.min_val = []

    def push(self, value: int) -> None:
        if self.val_is_empty() or value <= self.top_val():
            self.min_val.append(value)
        self.min_stack.append(value)

    def pop(self) -> None:
        if self.top_val() == self.top():
            self.min_val.pop()
        return self.min_stack.pop()

    def top(self) -> int:
        return self.min_stack[-1]

    def top_val(self):
        return self.min_val[-1]

    def getMin(self) -> int:
        return self.top_val()

    def val_is_empty(self):
        return len(self.min_val) == 0


# Your MinStack object will be instantiated and called as such:
# obj = MinStack()
# obj.push(value)
# obj.pop()
# param_3 = obj.top()
# param_4 = obj.getMin()


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: two stacks (values + mins). First version.
#
# Idea: one min variable breaks when you pop the current min; you lose the old one.
# So keep a second stack whose top is ALWAYS the current min.
#
# Steps:
#   push(v): if min stack empty or v <= its top -> push v onto min stack too
#            always push v onto the main stack
#   pop():   if the value leaving == top of min stack -> pop min stack too
#            pop main stack
#   top():    main stack's last item
#   getMin(): min stack's last item
#
# Why `<=` not `<`: push 0, push 0, pop -> the min must still be 0.
# With `<` only one 0 goes on the min stack and the pop removes it.
#
# Big-O: every operation O(1); O(n) space.
# Cleaner redo with shared helpers -> 155_min_stack_redo.py
