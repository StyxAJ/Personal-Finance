# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def mergeTwoLists(
        self, list1: ListNode | None, list2: ListNode | None
    ) -> ListNode | None:
        dummy = ListNode()
        tail = dummy
        while list1 and list2:
            if list1.val <= list2.val:
                tail.next = list1
                list1 = list1.next
            else:
                tail.next = list2
                list2 = list2.next
            tail = tail.next
        tail.next = list1 or list2
        return dummy.next


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: dummy node + tail pointer.
#
# Idea: build the result by attaching the smaller head each time.
# A dummy node in front means there's no special case for "first node".
#
# Steps:
#   dummy = ListNode(); tail = dummy
#   while both lists have nodes:
#     attach the smaller head to tail.next, move that list forward
#     tail = tail.next
#   tail.next = list1 or list2   (attach whatever is left; it's already sorted)
#   return dummy.next            (skip the dummy)
#
# Trace: 1->2->4 and 1->3->4
#   1(l1) 1(l2) 2 3 4(l1) -> l1 empty -> attach 4 from l2
#   -> 1->1->2->3->4->4
#
# `<=` takes from list1 on ties (keeps it stable).
# `list1 or list2` = the one that isn't None.
#
# Big-O: O(n + m) time, O(1) extra space (reuses the existing nodes).
