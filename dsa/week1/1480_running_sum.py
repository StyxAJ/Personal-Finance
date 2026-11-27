class Solution:
    def runningSum(self, nums: list[int]) -> list[int]:
        total = 0
        for i in range(len(nums)):
            total = nums[i] + total
            nums[i] = total
        return nums


# O(n): the loop runs once per item, and each step does constant work.


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Problem: answer[i] = nums[0] + nums[1] + ... + nums[i].
# Pattern: prefix sum (running total).
#
# Idea: each answer = previous answer + current number,
# so keep ONE running total instead of re-adding from the start.
#
# Steps:
#   total = 0
#   for each index i: total += nums[i], then write total back into nums[i]
#   return nums (overwritten in place)
#
# Trace: [1, 2, 3, 4]
#   i=0 total=1  -> [1, 2, 3, 4]
#   i=1 total=3  -> [1, 3, 3, 4]
#   i=2 total=6  -> [1, 3, 6, 4]
#   i=3 total=10 -> [1, 3, 6, 10]
#
# Big-O: O(n) time, O(1) extra space (reuses nums).
# Re-summing from 0 for every i would be O(n^2).
