#Leet code solution

class Solution:
    def searchInsert(self, nums: list[int], target: int) -> int:
        left, right = 0, len(nums) - 1
        while left <= right:
            mid = (left + right) // 2
            if nums[mid] == target:
                return mid
            elif nums[mid] < target:
                left = mid + 1
            else:
                right = mid - 1
        return left

# self test 
class Solution:
    def searchInsert(self, nums: list[int], target: int) -> int:
        left, right = 0, len(nums) - 1
        while left <= right:
            mid = left + (right - left) // 2    #get the mif
            if  nums[mid] == target:    #check mid is target
                return mid
            elif nums[mid] < target:    #move left to mid
                left = mid + 1
            else:
                right = mid - 1    #move right to mid
        return left


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: binary search; return `left` when not found.
#
# Same as LC 704, except the last line returns left instead of -1.
# When the loop ends (left > right), left = the first index whose value
# is bigger than target = where target would be inserted.
#
# Trace: [1, 3, 5, 6], target 2
#   mid=1 (3) > 2 -> right=0
#   mid=0 (1) < 2 -> left=1
#   left > right -> return 1
#
# Edge cases: target bigger than everything -> len(nums); smaller -> 0.
#
# Watch out (from the redo): left = mid / right = mid instead of mid +- 1 -> infinite loop.
# Note: both classes are named Solution, so the second one replaces the first.
#
# Big-O: O(log n) time, O(1) space.
