# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def reverseList(self, head: ListNode | None) -> ListNode | None:
        prev = None
        current = head
        while current is not None:
            next_node = current.next  # Store the next node
            current.next = prev  # Reverse the link
            prev = current  # Move prev to current
            current = next_node  # Move to the next node
        return prev


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: pointer reversal with prev / current / saved next.
#
# Idea: walk the list once and flip each arrow to point backwards.
# Before flipping, SAVE current.next, or you lose the rest of the list.
#
# Steps (order matters):
#   prev = None, current = head
#   while current:
#     next_node = current.next   1. save the rest
#     current.next = prev        2. flip the arrow
#     prev = current             3. prev steps forward
#     current = next_node        4. current steps forward
#   return prev   (current is None, prev is the old last node = new head)
#
# Trace: 1 -> 2 -> 3 -> None
#   round 1: None <- 1      rest 2 -> 3
#   round 2: None <- 1 <- 2 rest 3
#   round 3: None <- 1 <- 2 <- 3 -> return 3
#
# Think of it as: peel one box off the front, prepend it to the reversed list.
# ListNode is commented out because LeetCode provides it.
# Big-O: O(n) time, O(1) space.
