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
