# Given two strings ransomNote and magazine, return true if ransomNote can be constructed by using the letters from magazine and false otherwise.

# Each letter in magazine can only be used once in ransomNote.


class Solution:
    def canConstruct(self, ransomNote: str, magazine: str) -> bool:
        counts = {}
        for ch in magazine:
            counts[ch] = counts.get(ch, 0) + 1
        for ch in ransomNote:
            if counts.get(ch, 0) == 0:
                return False
            counts[ch] -= 1
        return True


s = Solution()
print(s.canConstruct("a", "b"))  # False
print(s.canConstruct("aa", "ab"))  # False
print(s.canConstruct("aa", "aab"))  # True


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: hash map counting, "can I build A from the letters of B?"
#
# Idea: magazine is the supply, ransomNote is the demand.
# Count the supply, then spend it letter by letter.
#
# Steps:
#   counts = letter -> how many in magazine
#   for each ch in ransomNote:
#     counts.get(ch, 0) == 0 -> False (ran out / never had it)
#     else counts[ch] -= 1
#   -> True
#
# `counts.get(ch, 0)` returns 0 instead of raising KeyError for a missing letter.
#
# Trace: ("aa", "aab") -> counts {a:2, b:1} -> spend a (1), spend a (0) -> True
#        ("aa", "ab")  -> counts {a:1, b:1} -> spend a (0), next a is 0 -> False
#
# Big-O: O(m + n) time, O(1) space (26 letters max).
