class Solution:
    def twoSum(self, numbers: list[int], target: int) -> list[int]:
        indexL = 0
        indexR = len(numbers) - 1
        while True:
            sum_nums = numbers[indexL] + numbers[indexR]
            if sum_nums == target:
                return [indexL + 1, indexR + 1]
            elif sum_nums > target:
                indexR -= 1
            else:
                indexL += 1
