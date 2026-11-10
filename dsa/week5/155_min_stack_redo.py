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
