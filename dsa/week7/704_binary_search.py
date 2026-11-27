#done and tested

class Solution:
    def search(self, nums: list[int], target: int) -> int:
        left, right = 0, len(nums) - 1

        while left <= right:
            mid = left + (right - left) // 2

            if nums[mid] == target:
                return mid
            elif nums[mid] < target:
                left = mid + 1
            else:
                right = mid - 1
        return -1

# self test using recursion
class Solution:
    def search(self, nums: list[int], target: int) -> int:
        return self.helper(nums, target, 0, len(nums) - 1)

    def helper(self, nums, target, low, high):
        if low > high:              # base case: fingers crossed, gap is empty
            return -1

        mid = low + (high - low) // 2
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            return self.helper(nums, target, mid + 1, high)   # search the right side
        else:
            return self.helper(nums, target, low, mid - 1)   # search the left side


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: binary search on a sorted array.
#
# Idea: look at the middle; throw away the half that can't contain target.
#
# Steps (loop):
#   left, right = 0, n - 1
#   while left <= right:
#     mid = left + (right - left) // 2
#     equal -> return mid
#     too small -> left = mid + 1   (mid already checked, skip it)
#     too big   -> right = mid - 1
#   return -1
#
# Why `<=`: when left == right there's still one item to check.
# Why mid +- 1: mid is already checked; left = mid can loop forever.
# left + (right - left) // 2 = same as (left + right) // 2, but avoids overflow in other languages.
#
# Recursive version: helper(low, high) with the same rules; base case low > high -> -1.
# Pass low/high, don't slice: slicing copies (O(n)) and the index
# would be counted from the slice, not the original list.
#
# Big-O: O(log n) time; 1,000,000 items ~ 20 steps.
# Space: loop O(1), recursion O(log n) (call stack).
