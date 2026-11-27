class MinStack:
    def __init__(self):
        self.main_stack = []
        self.min_stack = []

    def _is_empty(self, stack) -> bool:
        return len(stack) == 0

    def _peek(self, stack) -> int:
        return stack[-1]

    def push(self, value: int) -> None:
        if self._is_empty(self.min_stack) or value <= self._peek(self.min_stack):
            self.min_stack.append(value)
        self.main_stack.append(value)

    def pop(self) -> None:
        if self._peek(self.main_stack) == self._peek(self.min_stack):
            self.min_stack.pop()
        self.main_stack.pop()

    def top(self) -> int:
        return self._peek(self.main_stack)

    def getMin(self) -> int:
        return self._peek(self.min_stack)


# Your MinStack object will be instantiated and called as such:
# obj = MinStack()
# obj.push(value)
# obj.pop()
# param_3 = obj.top()
# param_4 = obj.getMin()


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Same idea as 155_min_stack.py, rewritten from blank.
#
# Difference: _is_empty(stack) and _peek(stack) take the stack as a parameter,
# so ONE helper works for both main_stack and min_stack.
#
# Rules:
#   push: min stack empty or value <= its top -> also push to min stack
#   pop:  value leaving == min stack top -> also pop min stack
#   getMin: peek min stack
#
# Trace: push 5, push 3, push 7, push 3
#   main [5, 3, 7, 3]   min [5, 3, 3]   getMin 3
#   pop 3 -> min [5, 3]  getMin 3
#   pop 7 -> min [5, 3]  getMin 3 (7 was never in min)
#   pop 3 -> min [5]     getMin 5
#
# Big-O: O(1) per operation, O(n) space.
