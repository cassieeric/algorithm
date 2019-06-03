# -*- coding: utf-8 -*-
a = [7, 11, 8, 12, 18, 2, 5, 9]
for i in range(len(a)-1):
    for j in range(len(a)-1-i):
        if a[j] > a[j + 1]:
            a[j], a[j + 1] = a[j + 1], a[j]

print(a)
