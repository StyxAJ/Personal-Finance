class Solution:
    def pivotIndex(self, nums: list[int]) -> int:
        r_sum = sum(nums)
        l_sum = 0
        for i in range(len(nums)):
            if i != 0:
                r_sum = r_sum - nums[i]
                l_sum = l_sum + nums[i - 1]
            else:
                r_sum = r_sum - nums[i]
            if l_sum == r_sum:
                return i
            else:
                i += 1
        return -1


# Paper: [1,7,3,6,5,6] -> 3
# i=0 R=27 L=0 | i=1 R=20 L=1 | i=2 R=17 L=8 | i=3 R=11 L=11 ✓
# Steps: L=0, R=total; loop: R-=x, compare, L+=x; return -1
