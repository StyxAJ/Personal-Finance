<!-- Format: #number Name | pattern | key idea in my words | solved alone / needed hint -->

#1 Big-O | concept: Quadratic | loop inside a loop over n = O(n²); constants are dropped | -


<!-- DSA -->

#2 Hidden loop | one line inside a loop that is itself O(n), e.g. list.insert(0, x) in a for loop = O(n²) |  | 

#3 Built-in costs | append / pop() / lst[i] = O(1); insert(0) / pop(0) / x in list / index() / slicing / sum() = O(n); use deque.appendleft() for O(1) front insert |  | 

#4 Measure growth, not one run | time at n, 2n, 4n: ~2x each step = O(n), ~4x each step = O(n²) |  | 

#5 Add vs multiply | loop then loop = O(n) + O(n) = O(n); loop inside loop = O(n) * O(n) = O(n²) |  | 

#6 Drop lower-order terms | O(n² + n) -> O(n²), the biggest term wins as n grows |  | 

#7 Two different inputs | for a in A: for b in B -> O(n*m), not O(n²) |  | 

#8 Unique pairs | inner loop starts at i+1 -> n(n-1)/2 steps, still O(n²) |  | 

#9 Space complexity | building a list of n items = O(n) space; a few variables only = O(1) extra space |  | 

#10 Best vs worst case | early return makes best case cheaper (linear search: O(1) best, O(n) worst); Big-O usually means worst |  | 


<!-- SQL -->

#11 = vs LIKE | = for exact match; LIKE only with % or _ wildcards |  | 

#12 Quotes | 'single' = string value, "double" = column/table name (Postgres) |  | 

#13 Top-N | ORDER BY col DESC LIMIT n |  | 

#14 Nth item / pagination | ORDER BY col LIMIT k OFFSET m (3rd & 4th largest = LIMIT 2 OFFSET 2) |  | 

#15 LIMIT needs ORDER BY | without ORDER BY the rows returned are arbitrary |  | 

#16 Execution order | FROM/JOIN -> WHERE -> SELECT -> DISTINCT -> ORDER BY -> LIMIT |  | 

#17 Find rows with no match | LEFT JOIN b ON ... WHERE b.key IS NULL (e.g. buildings with no employees) |  | 

#18 NULL checks | use IS NULL / IS NOT NULL; = NULL is never true |  | 

#19 LEFT JOIN trap | a WHERE condition on the right table after a LEFT JOIN turns it into an INNER JOIN |  | 

#20 Qualify columns | write table.column in ON / SELECT when joining so names are never ambiguous |  | 


<!-- DSA <-> SQL -->

#21 WHERE without index | checks every row = O(n) scan, like sum_list |  | 

#22 Naive JOIN | compare every row of A with every row of B = O(n*m), same as nested loop |  | 

#23 ORDER BY + LIMIT | still sorts everything first (~O(n log n)); LIMIT shrinks output, not work |  | 

#24 Leading wildcard | LIKE '%abc%' can't use an index -> full O(n) scan |  | 

