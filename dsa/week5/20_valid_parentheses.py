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


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: stack + dict (closer -> opener).
#
# Idea: the LAST bracket opened must be the FIRST one closed -> LIFO -> stack.
#
# Steps:
#   stack = [], bracket_map = {")": "(", "}": "{", "]": "["}
#   for each char:
#     opener -> push it
#     closer -> stack empty OR popped top != its opener -> False
#   end -> valid only if the stack is empty (no unclosed openers)
#
# Trace: "([)]"
#   ( push, [ push, ) pops [ but needs ( -> False
#   (counting brackets would say this is fine, that's why order needs a stack)
#
# Watch out:
#   "]"  -> closer on an empty stack -> must check `not stack` before popping
#   "((" -> loop finishes fine, but the stack isn't empty -> return `not stack`
#
# Big-O: O(n) time, O(n) space.
