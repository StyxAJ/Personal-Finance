class Solution:
    def runningSum(self, nums: list[int]) -> list[int]:
        total = 0
        for i in range(len(nums)):
            total = nums[i] + total
            nums[i] = total
        return nums


# O(n): the loop runs once per item, and each step does constant work.
