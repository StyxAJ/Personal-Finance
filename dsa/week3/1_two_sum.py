class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        seen = {}
        for index, val in enumerate(nums):
            need = target - val
            if need in seen:
                return [seen[need], index]
            seen[val] = index
