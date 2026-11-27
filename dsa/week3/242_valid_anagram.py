class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False
        counts = {}
        for ch in s:
            counts[ch] = counts.get(ch, 0) + 1
        for ch in t:
            if counts.get(ch, 0) == 0 or counts[ch] == 0:
                return False
            counts[ch] -= 1
        return True


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: hash map counting (same as LC 383 + a length check).
#
# Idea: an anagram uses the same letters the same number of times.
# Count s up (+1), then spend the counts with t (-1).
#
# Steps:
#   lengths differ -> False
#   counts[ch] = counts.get(ch, 0) + 1   for each ch in s
#   for each ch in t:
#     count missing or already 0 -> False (t has an extra ch)
#     else counts[ch] -= 1
#   -> True
#
# Why the length check matters: without it, s = "ab", t = "a" would pass
# (every ch in t is covered, but s has leftovers).
#
# Note: `counts.get(ch, 0) == 0` already covers `counts[ch] == 0`, so the
# second half of the `or` is never needed.
#
# Big-O: O(n) time, O(1) space (at most 26 lowercase letters).
