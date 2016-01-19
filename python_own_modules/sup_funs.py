import os
import errno


def print_(msg):
    """Printing the message in a formatted,structured way."""

    print('\n************************************************')
    print '\t{}'.format(msg)
    print('************************************************\n')


def force_symlink(file1, file2):
    """Implementing the ln -sf functionality

    First ovewrite file1, then make the symliknk again.
    """
    try:
        os.symlink(file1, file2)
    except OSError, e:
        if e.errno == errno.EEXIST:
            os.remove(file2)
            os.symlink(file1, file2)


def touch(fname, times=None):
    """Implementing the touch UNIX command."""

    fhandle = open(fname, 'a')
    try:
        os.utime(fname, times)
    finally:
        fhandle.close()
