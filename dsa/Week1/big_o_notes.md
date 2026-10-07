# BIG-O

## Algorithm Analysis with Big-O Notation

The Big-O notation signifies the relation between the input to the algorithm to the steps required to execute the algorithm. we denote Big-O with "O(n)", where:
- The notation is denotes by a capital "O"
- "n" is the size of the input. The expression around it (n, n², log n) describes how the steps grow as n grows.
- machine independent

```text
The key takeaway is - the Big-O isn't interested in a particular instance in which you run an algorithm, such as fact(50), but rather, in how well it scales given increasing input. This is a much better metric for evaluating than concrete time for a concrete instance!
```

- Example and To build intuition:   
    At n=1, these two would perform the same! This is another reason why observing the relationship between the input and the number of steps to process that input is better than just evaluating functions with some concrete input.

    - O(n): at n=1, 1 step is taken. At n=10, 10 steps are taken.     --linear relationship
    - O(n²): at n=1, 1 step is taken. At n=10, 100 steps are taken.   --quadratic functions

### Most common Big-O functions

| Name | Big O |
|---|---|
| Constant | O(c) |
| Linear | O(n) |
| Quadratic | O(n²) |
| Cubic | O(n³) |
| Exponential | O(2ⁿ) |
| Logarithmic | O(log n) |
| Log linear | O(n log n) |

## Constant Complexity - O(C)

- The step complexity of an algorithm is said to be constant if the steps required to complete the execution remains the same, irrespective to the number of inputs. 
- The constant complexity is denoted by O(c) where c can be any constant number.

```python
def constant_algo(items):
    result = items[0] * items[0]
    print(result)


constant_algo([4, 5, 6, 8])
```

- In the script above, irrespective of the input size, or the number of items in the input list items, the algorithm performs only 2 steps:

    - Finding the square of the first element.
    - Printing the result on the screen.

Hence, the complexity remains constant.

## Linear Complexity - O(n)

- The complexity of an algorithm is said to be linear if the steps required to complete the execution of an algorithm increase or decrease linearly with the number of inputs.
- Linear complexity is denoted by O(n).

```python
def linear_algo(items):
    for item in items:
        print(item)


linear_algo([4, 5, 6, 8])
```

- The complexity of the linear_algo() function is linear in the above example since the number of iterations of the for-loop will be equal to the size of the input items array. For instance, if there are 4 items in the items list, the for-loop will be executed 4 times.

**NOTE:** With large inputs, constants tend to lose value. This is why we typically remove constants from Big-O notation, and an expression such as O(2n) is usually shortened to O(n). Both O(2n) and O(n) are linear - the linear relationship is what matters, not the concrete value. 

```python
def linear_algo(items):
    for item in items:
        print(item)

    for item in items:
        print(item)


linear_algo([4, 5, 6, 8])
```

## Quadratic Complexity - O(n²)

- The complexity of an algorithm is said to be quadratic when the steps required to execute an algorithm are a quadratic function of the number of items in the input.
- Quadratic complexity is denoted as O(n²).

```python
def quadratic_algo(items):
    for item in items:
        for item2 in items:
            print(item, " ", item2)


quadratic_algo([4, 5, 6, 8])
```
- An outer loop that iterates through all the items in the input list and then a nested inner loop, which again iterates through all the items in the input list. The total number of steps performed is n*n, where n is the number of items in the input array.