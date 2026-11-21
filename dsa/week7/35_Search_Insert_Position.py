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