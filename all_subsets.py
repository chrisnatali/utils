#!/bin/python

def all_subsets_rec(left, so_far, accum):
    if len(left) == 0:
        accum.append(so_far)
    else:
        # find subsets that include first item of left
        all_subsets_rec(left[1:], [left[0]] + so_far, accum)
        # find subsets that do NOT include first item of left
        all_subsets_rec(left[1:], so_far, accum)


def all_subsets(items):
    accum = []
    all_subsets_rec(items, [], accum)
    return accum

