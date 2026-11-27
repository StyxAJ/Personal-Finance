class Solution:
    def isPalindrome(self, s: str) -> bool:
        i, j = 0, len(s) - 1
        while i < j:
            while i < j and not s[i].isalnum():
                i += 1
            while i < j and not s[j].isalnum():
                j -= 1
            if s[i].lower() != s[j].lower():
                return False
            i += 1
            j -= 1

        return True


# A phrase is a palindrome if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward. Alphanumeric characters include letters and numbers.


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: two pointers from both ends, moving inward.
#
# Idea: compare the outside characters and walk in. Skip anything that
# isn't a letter/digit, and compare in lowercase.
#
# Steps:
#   i = 0, j = last index
#   while i < j:
#     move i right while s[i] is junk (and i < j)
#     move j left  while s[j] is junk (and i < j)
#     if s[i].lower() != s[j].lower() -> False
#     i += 1, j -= 1
#   -> True (every pair matched)
#
# Trace: "A man, a plan" -> compares a/n... ; "race a car" -> 'e' vs 'a' -> False
#
# Watch out: the inner whiles need `i < j` too, otherwise a string of only
# junk ("., ") walks the pointers past each other / out of range.
#
# Big-O: O(n) time, O(1) space (no cleaned copy of the string).
