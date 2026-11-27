class Solution:
    def pivotIndex(self, nums: list[int]) -> int:
        r_sum = sum(nums)
        l_sum = 0
        for i in range(len(nums)):
            if i != 0:
                r_sum = r_sum - nums[i]
                l_sum = l_sum + nums[i - 1]
            else:
                r_sum = r_sum - nums[i]
            if l_sum == r_sum:
                return i
            else:
                i += 1
        return -1


# Paper: [1,7,3,6,5,6] -> 3
# i=0 R=27 L=0 | i=1 R=20 L=1 | i=2 R=17 L=8 | i=3 R=11 L=11 ✓
# Steps: L=0, R=total; loop: R-=x, compare, L+=x; return -1


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: prefix sum (left sum vs right sum).
#
# Idea: at index i, left = sum before i, right = sum after i.
# Start with right = total, then for each i:
#   take nums[i] out of the right, compare, then add nums[i] to the left.
#
# Clean version of the same logic:
#   total_right = sum(nums), left = 0
#   for i, x in enumerate(nums):
#     total_right -= x
#     if left == total_right: return i
#     left += x
#   return -1
#
# Note: `i += 1` inside a `for` loop does nothing (the for sets i again each round).
# The code adds nums[i - 1] to the left at the START of each round instead of
# nums[i] at the END; same result.
#
# Big-O: O(n) time (one sum + one pass), O(1) space.
