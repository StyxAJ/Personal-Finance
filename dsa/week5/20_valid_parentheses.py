class Solution:
    def isValid(self, s: str) -> bool:
        stack = []
        bracket_map = {")": "(", "}": "{", "]": "["}

        for char in s:
            if char in bracket_map.values():
                stack.append(char)
            elif char in bracket_map:
                if not stack or stack.pop() != bracket_map[char]:
                    return False
        return not stack


# 1. Before the loop: make an empty ___ and a dict that maps each ___ bracket to its ___ bracket.
# 2. For each char:
#    a. if it's an opening bracket → ___
#    b. if it's a closing bracket:
#       - if the stack is empty → ___
#       - if the top isn't its partner → ___
#       - otherwise → ___
# 3. After the loop: return ___
