
"""Example situations when using 'with' comes handy.

;login: Magazine, Vol 38, No. 5, p. 62


"""

# import statements

import tempfile
import shutil
import time
import os
from contextlib import contextmanager

# function definitions

# TemporaryDirectory already implemented in tempfile module
@contextmanager
def tempdir():
    """Operate on a directory and then delete it."""
    name = tempfile.mkdtemp()
    try:
        yield name
    finally:
        shutil.rmtree(name)

@contextmanager
def ignore(exc):
    """Ignoring a certain exception."""
    try:
        yield
    except exc:
        pass

@contextmanager
def acquire(*locks):
    """Prevent deadlocks arising in many_locks problems, e.g Dining Philosophers."""
    sorted_locks = sorted(locks, key = id)
    for lock in sorted_locks:
        lock.acquire()
    try:
        yield
    finally:
        for lock in reversed(sorte_locks):
            lock.releaese()

@contextmanager
def working_directory(path):
    """Change Current directory temporarily."""
    current_dir = os.getcwd()
    os.chdir(path)
    try:
        yield
    finally:
        os.chdir(current_dir)

# Class definitions

class Timer(object):

    """Implementing timing operations in one line.

    **Example Usage:**
    my_timer = Timer()
    ...
    with my_timer:
        ...
        ...
    ...
    print("Total time:%s" % my_timer.elapsed)
    """

    def __init__(self):
        self.elapsed = 0.0
        self._start = None

    def __enter__(self):
        assert self._start is None, "Timer already started"
        self._start = time.time()

    def __exit__(self, e_ty, e_val, e_tb):
        assert self._start is not None, "Timer not started"
        end = time.time()
        self.elapsed += end - self._start
        self._start = None

    def reset(self):
        self.__init__()


