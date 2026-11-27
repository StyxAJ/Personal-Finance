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


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: binary search twice (rows, then inside one row).
#
# Matrix rules: each row is sorted, and each row's first value > the previous row's last.
# So read row by row, it's one long sorted list.
#
# Steps:
#   1. Binary search the ROWS on their first value (matrix[mid][0]).
#      When it ends, bottom = last row whose first value <= target
#      (same "where would it go" idea as LC 35).
#      bottom < 0 -> target is smaller than everything -> False
#   2. Plain binary search (LC 704) inside matrix[bottom].
#
# Trace: [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target 3
#   rows: mid=1 first 10 > 3 -> bottom=0; mid=0 first 1 < 3 -> top=1; stop, row 0
#   row 0: [1,3,5,7] -> found 3 -> True
#
# len(matrix) = number of rows, len(matrix[0]) = number of columns.
# Big-O: O(log m + log n) time, O(1) space.
# (v1 looped over the rows = O(m + log n).)
# Other way: treat it as one list of m*n items, row = i // n, col = i % n.
