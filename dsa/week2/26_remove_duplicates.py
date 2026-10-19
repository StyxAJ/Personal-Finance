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
