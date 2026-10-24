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
