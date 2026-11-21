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