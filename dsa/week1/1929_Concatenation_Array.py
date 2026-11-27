class Solution:
    def getConcatenation(self, nums: list[int]) -> list[int]:
        ans = nums + nums
        return ans


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Problem: return nums followed by nums again (length 2n).
# Pattern: plain list operation.
#
# Idea: `+` on two lists builds a NEW list = left items then right items.
#   [1, 2, 1] + [1, 2, 1] -> [1, 2, 1, 1, 2, 1]
#
# Same thing other ways: nums * 2, or a loop that appends nums[i % n] for i in range(2n).
#
# Big-O: O(n) time and O(n) space (the new list has 2n items).
