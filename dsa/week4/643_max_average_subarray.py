class Solution:
    def findMaxAverage(self, nums: list[int], k: int) -> float:
        window_sum = sum(nums[:k])
        max_sum = window_sum
        for i in range(k, len(nums)):
            window_sum += nums[i] - nums[i - k]
            max_sum = max(max_sum, window_sum)

        return max_sum / k


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: sliding window, fixed size k.
#
# Idea: the next window = previous window + new item on the right - old item on the left.
# No need to re-add k numbers each time.
#
# Steps:
#   window_sum = sum of the first k
#   max_sum = window_sum
#   for i from k to the end:
#     window_sum += nums[i] - nums[i - k]   (add newcomer, drop the one leaving)
#     max_sum = max(max_sum, window_sum)
#   return max_sum / k   (divide once at the end)
#
# Trace: [1, 12, -5, -6, 50, 3], k = 4
#   first window 1+12-5-6 = 2
#   i=4: +50 -1  -> 51
#   i=5: +3  -12 -> 42
#   -> 51 / 4 = 12.75
#
# Big-O: O(n) time, O(1) space. Summing every window from scratch = O(n*k).
