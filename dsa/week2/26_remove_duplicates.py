# 26. Remove Duplicates from Sorted Array
#
# Given an integer array nums sorted in non-decreasing order, remove the duplicates in-place
# such that each unique element appears only once. The relative order of the elements should
# be kept the same.
#
# Consider the number of unique elements in nums to be k. After removing duplicates, return
# the number of unique elements k.
#
# The first k elements of nums should contain the unique numbers in sorted order. The remaining
# elements beyond index k - 1 can be ignored.


class Solution:
    def removeDuplicates(self, nums: list[int]) -> int:
        write = 0
        i = 0
        size = len(nums)
        while i < (size - 1):
            if nums[i] != nums[i + 1]:
                write += 1
                nums[write] = nums[i + 1]
            i += 1

        return write + 1


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: two pointers, same direction (slow = write, fast = read).
#
# Idea: the array is sorted, so duplicates sit next to each other.
# `write` points at the last UNIQUE value kept so far.
# `i` scans pairs; when nums[i] != nums[i+1], nums[i+1] is a new value.
#
# Steps:
#   write = 0 (nums[0] is always kept)
#   for each neighbour pair (i, i+1):
#     if different -> write += 1, nums[write] = nums[i+1]
#   return write + 1 (count of uniques)
#
# Trace: [0, 0, 1, 1, 2]
#   (0,0) same
#   (0,1) new -> write=1, nums=[0,1,1,1,2]
#   (1,1) same
#   (1,2) new -> write=2, nums=[0,1,2,1,2]
#   return 3 -> first 3 items are [0, 1, 2]
#
# Big-O: O(n) time, O(1) space (in place).
