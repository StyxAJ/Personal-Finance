class Solution:
    def merge(self, intervals: list[list[int]]) -> list[list[int]]:
        merged_list =  []
        intervals.sort(key=lambda x: x[0])   # sort by the start of each pair

        for start,end in intervals:
            if not merged_list or start > merged_list[-1][1]:
                merged_list.append([start, end])
            else:
                merged_list[-1][1] = max(merged_list[-1][1], end)

        return merged_list


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: sort + compare with the last merged interval.
#
# Idea: after sorting by start, an interval can only overlap the LAST one
# you've kept, so one pass replaces a double loop.
#
# Steps:
#   intervals.sort(key=lambda x: x[0])
#   for start, end in intervals:
#     merged empty OR start > merged[-1][1] (gap) -> append [start, end]
#     else (overlap) -> merged[-1][1] = max(merged[-1][1], end)
#   return merged
#
# Trace: [[1,3],[8,10],[2,6],[15,18]] -> sorted [[1,3],[2,6],[8,10],[15,18]]
#   [1,3]   -> [[1,3]]
#   [2,6]   2 <= 3 -> stretch to 6 -> [[1,6]]
#   [8,10]  8 > 6 -> [[1,6],[8,10]]
#   [15,18] -> [[1,6],[8,10],[15,18]]
#
# Watch out:
#   - `not merged_list` must come FIRST in the `or`; [][-1] -> IndexError
#   - max(), because [1,10] + [2,3] must stay [1,10]
#   - [1,4] + [4,5] touch -> 4 > 4 is False -> merged into [1,5]
#
# Big-O: O(n log n) time (the sort), O(n) space for the result.
