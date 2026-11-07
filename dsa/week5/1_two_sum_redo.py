class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        seen = {}  # where seens is a dict to store for each pass to get O(n) time complexity
        need_val = 0
        for index, val in enumerate(
            nums
        ):  # if i am not wrong, we use enumarate to get the index and value of the list at the same time
            need_val = (
                target - val
            )  # we try to get he difference between the target and the value at index
            if need_val in seen:  # if to see when we get a target value needed
                return [seen[need_val], index]  # if yeah, we return the value
            if (
                need_val not in seen
            ):  # if not, we store the value in the dict and move ahead
                seen[val] = index  # store the current state and move ahead
