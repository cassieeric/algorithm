# -*- coding: utf-8 -*-

def bubble_sort(list):
    for i in range(len(list) - 1):
        for j in range(len(list) - 1 - i):
            if list[j] > list[j + 1]:
                list[j], list[j + 1] = list[j + 1], list[j]

if __name__ == '__main__':
    list = [7, 11, 8, 12, 18, 2, 5, 9]
    print(list)
    bubble_sort(list)
    print(list)
