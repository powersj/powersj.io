---
title: "Numeric Data Duplication Detection"
date: 2017-07-18
tags: ["python"]
draft: false
aliases:
  - /post/data-numeric-duplication/
---

I recently had a friend ask for help going through a very large data set of his. After getting an overview of the data, both he and I agree that there are some interesting data points, statistics, and learning's that can be found from the data set.

While working on my masters, a key learning was understanding how the workflow of tackling a data science problem was essential. It can be very tempting to take data and a data science library or framework and start crunching. It is, however, required to start with framing the problem or question that needs to be answered. In doing so you give yourself direction, avoid 'boiling the ocean', and understand what you are trying to do in the first place. I assert this is similar to the hypothesis generation step found in the scientific method.

One of the first questions my friend and I had about the data set was centered around duplicate entries; whether those entries were identical or off only by slight amounts. This concern was founded by the nature of the data entered and the fact that much of the data was entered manually with no checks to prevent the duplication.

The first problem statement is then: how to detect the duplication of data.

## The Data

Here is what an example entry looks like in the data set:

```csv
<id>, <str>, <float>, <float>, <float>, <float>, <float>, <float>, <float>, ...
```

There are three data types:

* The id value used as an index in the database
* A single human-readable string used to identify the data
* A few dozen ordered float values.

Focusing on comparing the float values first seemed like a good place to start comparing entries. Comparing numerical data is more straight forward than diving into string comparison. With the problem framed and the data already in hand, it was time to determine the methodology.

## Methodology

Considering the following test cases:

```csv
0, 'Widgit 1', 2.33, 23.0, 333.2, 98.3, 887.3, 0.0, 0.0
1, 'Widgit 1', 2.33, 23.0, 333.2, 98.3, 887.3, 0.0, 0.0
2, 'Widgit 1', 2.33, 23.0, 333.1, 98.3, 887.3, 0.0, 0.0
3, '1, Widgit', 2.33, 23.0, 333.2, 98.3, 887.3, 0.0, 0.0
4, 'xyzzy', 0.0, 0.0, 0.0, 1.1, 0.0, 0.0, 0.0
5, 'foobar', 14.9, 9.9, 7.5, 4.0, 9.33, 0.25, 32.0
```

I wanted to give my friend a quick approach of looking for duplicates in the data. What I came up with is the following:

```python
#!/usr/bin/env python3
"""Demonstrate comparing float values using NumPy."""
import numpy as np

raw_data = [
    [0, 'Widgit 1', 2.33, 23.0, 333.2, 98.3, 887.3, 0.0, 0.0],
    [1, 'Widgit 1', 2.33, 23.0, 333.2, 98.3, 887.3, 0.0, 0.0],
    [2, 'Widgit 1', 2.33, 23.0, 333.1, 98.3, 887.3, 0.0, 0.0],
    [3, '1, Widgit', 2.33, 23.0, 333.2, 98.3, 887.3, 0.0, 0.0],
    [4, 'xyzzy', 0.0, 0.0, 0.0, 1.1, 0.0, 0.0, 0.0],
    [5, 'foobar', 14.9, 9.9, 7.5, 4.0, 9.33, 0.25, 32.0],
]

data = {}
for item in raw_data:
    data[item[0]] = np.array(item[2:])

scores = np.zeros(shape=(len(data), len(data)))
for base_key, base_value in data.items():
    for compare_key, compare_value in data.items():
        score = np.linalg.norm(base_value - compare_value)
        scores[base_key][compare_key] = score

print(np.array2string(scores, formatter={'float_kind':'{0:6.1f}'.format}))
```

In order to compare two entries, this method takes the float values as a vector and subtracts one vector from the other. The result is a score, or distance, between the metrics.

## Results

The result from the example data is as follows:

```python
[[   0.0    0.0    0.1    0.0  953.1  941.9]
 [   0.0    0.0    0.1    0.0  953.1  941.9]
 [   0.1    0.1    0.0    0.1  953.0  941.9]
 [   0.0    0.0    0.1    0.0  953.1  941.9]
 [ 953.1  953.1  953.0  953.1    0.0   38.7]
 [ 941.9  941.9  941.9  941.9   38.7    0.0]]
```

A value of zero means the entries are identical and a duplicate entry is found! From the above, it is clear that the first, second, and fourth entries are identical. And, correctly, all entries along the diagonal contain zeros as there each value is subtracted from itself.

The next step in the analysis is how to derive meaning from the non-zero scores. Because a score of zero indicates a duplicate entry, then a score very close to zero indicates that items are very similar and a score far away from zero indicates items are very dissimilar.

Then how close to zero does a score need to be to indicate a duplicate entry that is explained by a typo? This is where deeper analysis is required in order to generate a heuristic. In the example test cases above it could be argued that a score of less than 1 is a good indicator that an entry deserves to be looked at. Similarly, a score well over 1 may indicate, that the entries are dissimilar enough to eliminate the possibility of a duplicate. However, not until the greater data set is used can a more accurate heuristic be determined.

## Reflection

For me, this was the first time I was able to go through this process outside of graduate school. While it felt a little too simple to come up with an initial solution it provided a simple initial process for analyzing the data. I left it to my friend to evaluate how to do this with tens of thousands of entries as all I wanted to do was demonstrate the process.

From here the next step is to hone the analysis further. Keeping it simple, but iterating over additional techniques such as looking at the string data.
