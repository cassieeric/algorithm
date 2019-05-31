# -*- coding: utf- 8 -*-

def partitions(list, low, high):
    left = low
    right = high
    k = list[low]
    while left < right:
        while list[left] <= k:
            left = left + 1
        while list[right] > k:
            right = right - 1
        if left < right:
            list[left], list[right] = list[right], list[left]
    list[low] = list[right]
    list[right] = k
    return right

def quicksort(list, low, high):
    if low < high:
        k = partitions(list, low, high)
        quicksort(list, low, k-1)
        quicksort(list, k+1, high)

if __name__ == '__main__':
    list_demo = [6, 1, 2, 7, 9, 3, 4, 5, 10, 8]
    print(list_demo)
    quicksort(list_demo, 0, len(list_demo)-1)
    print(list_demo)
