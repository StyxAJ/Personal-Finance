class Solution:
    def containsDuplicate(self, nums: list[int]) -> bool:
        unique_set = set()
        for i in nums:
            if i in unique_set:
                return True
            unique_set.add(i)
        return False


# Version 2: compare sizes. Also O(n), but always builds the full set, so it can't stop early


class Solution:
    def containsDuplicate(self, nums: list[int]) -> bool:
        return len(nums) != len(set(nums))
