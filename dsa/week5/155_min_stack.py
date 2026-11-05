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
