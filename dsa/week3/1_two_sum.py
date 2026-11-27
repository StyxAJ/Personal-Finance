class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        seen = {}
        for index, val in enumerate(nums):
            need = target - val
            if need in seen:
                return [seen[need], index]
            seen[val] = index


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: hash map, number -> index.
#
# Idea: for each x, the partner I need is target - x.
# Ask the dict "have I already seen that partner?" in O(1).
#
# Steps:
#   seen = {}
#   for index, val in enumerate(nums):
#     need = target - val
#     if need in seen -> return [seen[need], index]
#     seen[val] = index          (store AFTER checking)
#
# Why check before storing: nums = [3, 3], target = 6.
# Storing first would let 3 pair with itself; checking first finds the earlier 3.
#
# Trace: [2, 7, 11, 15], target 9
#   i=0 val=2 need=7 not seen -> seen={2:0}
#   i=1 val=7 need=2 seen!    -> [0, 1]
#
# Big-O: O(n) time, O(n) space. Double loop would be O(n^2).
