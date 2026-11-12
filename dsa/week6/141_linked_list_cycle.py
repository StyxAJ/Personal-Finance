class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None


class Solution:
    def hasCycle(self, head: Optional[ListNode]) -> bool:
        seen = set()
        current = head
        while current is not None:
            if current in seen:
                return True
            seen.add(current)
            current = current.next
        return False


# Test 1: 3 -> 2 -> 0 -> -4 -> back to 2  (cycle, expect True)
a, b, c, d = ListNode(3), ListNode(2), ListNode(0), ListNode(-4)
a.next, b.next, c.next = b, c, d
d.next = b  # this line makes the cycle (pos = 1)
print(Solution().hasCycle(a))  # True

# Test 2: 1 -> 1 -> None  (repeated value, no cycle, expect False)
x, y = ListNode(1), ListNode(1)
x.next = y
print(Solution().hasCycle(x))  # False

# Test 3: empty list (expect False)
print(Solution().hasCycle(None))  # False
