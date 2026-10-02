"""Placebo machinery: re-run the estimator on matched ordinary weekend days."""
import numpy as np
from core import event_terms, share, placebo_events


def placebo_matrix(M, events, kind="makeup", K=300, seed=0):
    rng = np.random.default_rng(seed)
    nums, dens = [], []
    for k in range(K):
        pe = placebo_events(M, events, rng, kind)
        A, W, E, used = event_terms(M, pe, kind)
        n, d = share(A, W, E, kind)
        nums.append(n); dens.append(d)
    return np.array(nums).T, np.array(dens).T  # repos x K
