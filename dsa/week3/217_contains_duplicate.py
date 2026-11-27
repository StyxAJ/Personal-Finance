class Solution:
    def containsDuplicate(self, nums: list[int]) -> bool:
        unique_set = set()
        for i in nums:
            if i in unique_set:
                return True
            unique_set.add(i)
        return False


# Version 2: compare sizes. Also O(n), but always builds the full set, so it can't stop early


class Solution:
    def containsDuplicate(self, nums: list[int]) -> bool:
        return len(nums) != len(set(nums))


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: hash set, "have I seen this before?"
#
# Version 1 (early exit):
#   for each x: if x in seen -> True; else seen.add(x)
#   end of loop -> False
#   Stops as soon as the first duplicate shows up.
#
# Version 2 (size compare):
#   set(nums) drops duplicates, so if it's shorter than nums there was a repeat.
#   One line, but always builds the whole set.
#
# Why a set: `x in set` is O(1); `x in list` is O(n) (makes the whole thing O(n^2)).
#
# Note: both classes are called Solution, so the second one replaces the first
# when this file runs. Fine for reference, LeetCode only takes one.
#
# Big-O: O(n) time, O(n) space for both.
