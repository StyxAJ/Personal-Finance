class Solution:
    def sortedSquares(self, nums: list[int]) -> list[int]:
        size = len(nums)
        result = [0] * size

        left, right = 0, size - 1
        pos = size - 1
        while left <= right:
            sqLeft, sqRight = nums[left] ** 2, nums[right] ** 2
            if sqLeft > sqRight:
                result[pos] = sqLeft
                left += 1
            else:
                result[pos] = sqRight
                right -= 1

            pos -= 1
        return result


# Given an integer array nums sorted in non-decreasing order, return an array of the squares of each number sorted in non-decreasing order.


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: two pointers from opposite ends + fill the result from the BACK.
#
# Idea: the array is sorted but may have negatives, e.g. [-4, -1, 0, 3, 10].
# The BIGGEST square is always at one of the two ends (big negative or big positive).
# So compare the ends, put the bigger square in the last empty slot, move that pointer in.
#
# Steps:
#   result = [0] * n, pos = n - 1
#   left = 0, right = n - 1
#   while left <= right:
#     bigger of nums[left]^2 and nums[right]^2 -> result[pos]
#     move the pointer that was used; pos -= 1
#
# Trace: [-4, -1, 0, 3, 10]
#   16 vs 100 -> 100 at pos 4
#   16 vs 9   -> 16  at pos 3
#   1  vs 9   -> 9   at pos 2
#   1  vs 0   -> 1   at pos 1
#   0  vs 0   -> 0   at pos 0   -> [0, 1, 9, 16, 100]
#
# Watch out: `<=` not `<`, the last middle element still needs a slot.
# Big-O: O(n) time, O(n) space for result (square + sort would be O(n log n)).
