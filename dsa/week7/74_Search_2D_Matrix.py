class Solution:
    def searchMatrix(self, matrix: list[list[int]], target: int) -> bool:
        if not matrix or not matrix[0]:
            return False

        top, bottom = 0, len(matrix) - 1
        while top <= bottom:
            mid = (top + bottom) // 2
            if matrix[mid][0] == target:
                return True
            elif matrix[mid][0] < target:
                top = mid + 1
            else:
                bottom = mid - 1        

        target_row = bottom
        if target_row < 0:
            return False


        left,right = 0, len(matrix[0]) - 1
        while left <= right:
            mid = left + (right - left) // 2
            if matrix[target_row][mid] == target:
                return True
            elif matrix[target_row][mid] < target:
                left = mid + 1
            else:
                right = mid - 1
        return False






        