class Solution:
    def twoSum(self, numbers: list[int], target: int) -> list[int]:
        indexL = 0
        indexR = len(numbers) - 1
        while True:
            sum_nums = numbers[indexL] + numbers[indexR]
            if sum_nums == target:
                return [indexL + 1, indexR + 1]
            elif sum_nums > target:
                indexR -= 1
            else:
                indexL += 1


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: two pointers from opposite ends on a SORTED array.
#
# Idea: sum = smallest + largest.
#   too big   -> the right number is too big, move R left  (sum shrinks)
#   too small -> the left number is too small, move L right (sum grows)
#   equal     -> found it
#
# Steps:
#   L = 0, R = last
#   loop: s = numbers[L] + numbers[R]
#         s == target -> return [L + 1, R + 1]   (problem uses 1-based indexes)
#         s > target  -> R -= 1
#         s < target  -> L += 1
#
# Trace: [2, 7, 11, 15], target 9
#   L=0 R=3: 2+15=17 > 9 -> R=2
#   L=0 R=2: 2+11=13 > 9 -> R=1
#   L=0 R=1: 2+7=9 -> [1, 2]
#
# `while True` is safe because the problem promises exactly one answer.
# Big-O: O(n) time, O(1) space (vs O(n) space for the hash map in LC 1).
