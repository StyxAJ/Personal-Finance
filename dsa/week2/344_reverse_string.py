class Solution:
    def reverseString(self, s: list[str]) -> None:
        """
        Do not return anything, modify s in-place instead.
        """
        i, j = 0, len(s) - 1
        while i < j:
            temp = s[j]
            s[j] = s[i]
            s[i] = temp
            i += 1
            j -= 1


# Write a function that reverses a string. The input string is given as an array of characters s.


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: two pointers from both ends, swap, move inward.
#
# Steps:
#   i = 0, j = last
#   while i < j: swap s[i] and s[j]; i += 1; j -= 1
#
# Trace: [h, e, l, l, o]
#   swap 0,4 -> [o, e, l, l, h]
#   swap 1,3 -> [o, l, l, e, h]
#   i=2, j=2 -> stop (the middle stays put)
#
# Swap with a temp variable (as written) or in one line:
#   s[i], s[j] = s[j], s[i]
#
# Big-O: O(n) time (n/2 swaps), O(1) space. Returns nothing: it changes s in place.
