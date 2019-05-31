# -*- coding: utf-8 -*-

def partitions(list, leftindex, rightindex):
    i = leftindex
    j = rightindex
    temp = list[i]
    while i < j:
        while i < j and temp <= list[j]:
            j -= 1
        list[i] = list[j]
        while i < j and temp >= list[i]:
            i += 1
        list[j] = list[i]
    list[i] = list[j]
    list[j] = temp
    return j

def quick_sort(list, leftindex, rightindex):
    if leftindex < rightindex:
        temp = partitions(list, leftindex, rightindex)
        quick_sort(list, leftindex, temp-1)
        quick_sort(list, temp+1, rightindex)

if __name__ == '__main__':
    list1 = [7, 11, 8, 12, 18, 2, 5, 9]
    print(list1)
    quick_sort(list1, 0, len(list1)-1)
    print(list1)

