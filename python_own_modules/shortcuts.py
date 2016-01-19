#############################
# GENERAL
#############################

# Get all the available methods of an object
[method for method in dir(object) if callable(getattr(object, method))]

# operate on a temporary file 
import tempfile
with  tempfile.TemporaryFile() as f:
    f.write(b'Hello World!')
    f.seek(0)
    f.read()

# print the time in the specified format
import time
now = time.strftime("%c")

# inline if-else statement
a = 'itis' if 5<4 else None

# split string at most maxsplit times
maxsplit = 1;
s = '1 2 3 4 5 5'
s.split(' ', maxsplit = maxsplit)


# get corresponding coordinates of an 1D flat index of an array
a = np.random.rand(3,3)
np.unravel_index(ind, a.shape)

# read an image
import os,sys
import Image
jpgfile = Image.open("picture.jpg")
print jpgfile.bits, jpgfile.size, jpgfile.format

# list all jpeg in a directory
list(entry for entry in os.listdir(thepath) if entry.endswith('.jpg'))

# walking a path recursively - os.walk
for dirpath, dirnames, filenames in os.walk(top_dir_path, topdown = True):
    # the returned tuple components do not include the full path
    for a_file in filenames:
        os.path.join([dirpath, a_file])

# spawn new processes and connect to their I/O/E pipes
import subprocess
# capture and return the std output from the program run
out = subprocess.check_output('.\\exiftool.exe', 'args'])
# output is formatted as a series of bytes -> decode it, 
caption = output.decode(encoding = 'utf_8').rstrip()

# high-level operations
import shutil
shutil.copy(src, dst)
shutil.move(src, dst)


# iterate over list of letters
# use their numeric values
for key in range(ord('A'), ord('Z') + 1):
    # change back to string representation
    print("{}".format(chr(key)))

li=[[1, 0.23],
    [2, 0.39],
    [4, 0.31],
    [5, 0.27]]
sorted(li,key=lambda l:l[1], reverse=True)

# copy a 2D list in python
import copy
a = [[random.randint(1, 10) for i in range(10)] for j in range(5)]
b = copy.deepcopy(a)

#############################
# FUNCTION-RELATED
#############################

# Parse the named-keywords arguement of a function
def __init__(self, **kwargs):       

    self.filename = kwargs.get('filename', 'lpo.db')
    self.table = kwargs.get('table', 'Weather')





#############################
# PANDAS | NUMPY | MATPLOTLIB
#############################
# Sat Oct 3 22:48:33 EEST 2015, nickkouk
# Created and inspired during the preparation of the Datathon 2015 Contest

# Run without python "word"
#!/opt/local/bin/python

# read a csv file
data =  pd.read_csv("mtcars.csv")

# plot interactively
ion()

# plot & show
plt.plot([1,2,3]); show()

# save the plot
plt.savefig("kalimera.png", bbox_inches="tight") # jpg, pdf, ..

# make graphs prettier - R style
rstyle(ax) # use this JUST BEFORE the plt.show() call

# ipython - save workspace - /w specific lines
# %save myhistory 1-67

# plot in specific axes
ax = df1.plot()
df2.plot(ax=ax)

# Rename a df in place
df.rename(columns = {df.columns[0]:'new_name'}, inplace = True)

# Apply a function to a dataFrame
df.new_name = df.new_name.map(lambda x: x.split('r')[0])
# Alternatively..
df.new_name = df.new_name.apply(lambda x: x.split('r')[0])

# Shape returns the shape of the df
df.shape

# plot data in subplot
fig, axes = plt.subplots(figsize=(10,10), nrows=2, ncols=2)
axes[0][0].plot(df.acol, df.anotherCol)
axes[0][1].plot(df.acol, df.anotherCol, '.') # plot with dots
axes[1][0].scatter(df.acol, df.anotherCol) # scatter plot
axes[1][1].hist(df.acol) # histogram


# Apply multiple functions at once
grouped['C'].agg([np.sum, np.mean, np.std])

# If a dict is passed, the keys will be used to name the columns. Otherwise the
# function’s name (stored in the function object) will be used.
grouped['D'].agg({'result1' : np.sum, 'result2' : np.mean})

# By passing a dict to aggregate you can apply a different aggregation to the
# columns of a DataFrame:

# Tilt the x_tick labels
fig, ax = plt.subplots()
ax.set_xticklabels(pSchools.School.head(), rotation=30)

# merge 2 dataFrames - concatenate
hlpSchools = pd.concat([hpSchools, lpSchools])

# hide xylabels
frame1.axes.get_xaxis().set_visible(False)
frame1.axes.get_yaxis().set_visible(False)

# use latex rendering
ax.set_title(r'\textit{Income and Expenditure - Public Schools}')

# filled BoxPlots
data = [np.random.normal(0, std, 1000) for std in range(1, 6)]
box = plt.boxplot(data, notch=True, patch_artist=True)
colors = ['cyan', 'lightblue', 'lightgreen', 'tan', 'pink']
for patch, color in zip(box['boxes'], colors):
    patch.set_facecolor(color)

# how to plot a pie
series.plot(kind='pie', labels=['AA', 'BB', 'CC', 'DD'], colors=['r', 'g', 'b',
'c'], autopct='%.2f', fontsize=20, figsize=(6, 6))

# frequency plot
ser.plot(kind='kde')

## datetime handling - Pandas
# To provide convenience for accessing longer time series, you can also pass in
# the year or year and month as strings:
# ts['2011']
# ts['2011-3']

# Suppressing Tick Resolution Adjustment
df.A.plot(x_compat=True)

## Layout - Subplots
# Using Layout and Targetting Multiple Axes
df.plot(subplots=True, layout=(2, 3), figsize=(6, 6), sharex=False);

# Alternative way.. 
fig, axes = plt.subplots(nrows=2, ncols=2)
df['A'].plot(ax=axes[0,0]); axes[0,0].set_title('A');
df['B'].plot(ax=axes[0,1]); axes[0,1].set_title('B');
df['C'].plot(ax=axes[1,0]); axes[1,0].set_title('C');
df['D'].plot(ax=axes[1,1]); axes[1,1].set_title('D');


#############################
# URLLIB
#############################
# classic import
from urllib import request 

# open a url the contents, and decode them
data[key] = request.urlopen('{}{}'.format(url, key)).read().decode(encoding='utf_8')



#############################
# PYSIDE - QT GUI
#############################

# Setup - Procedure
####################

#Make the UI - Designer app - Qt
#- have all the ui files in a separate directory for clarity

#Make Python modules out of the UI files
#tool="pyside-uic-2.7"
#$tool ../ui_files/Main_window.ui -o python_gui.py
#$tool ../ui_files/Settings.ui -o python_settings.py
#$tool ../ui_files/history_dialog.ui -o history_settings.py
#...
#...

#- You cal also have the PySide generated files in a directory of their own

#In your main module ...
## Usual importing stuff for PySide
#from PySide.QtGui import *
#from PySide.QtCore import *
## Qt-Designer compiled python code
#import python_gui
#import python_settings
#...
#...
#class MainWindow(QMainWindow, python_gui.Ui_MainWindow):


    #def __init__(self, parent=None):
        #super(MainWindow, self).__init__(parent)
        #self.setupUi(self)

        #self.__appname__ = "Pump3000"
        #self.setWindowTitle(self.__appname__)

#if __name__ == '__main__':
    #app = QApplication(sys.argv)



#############################
# TO KNOW | HINTS | TIPS
#############################


# PYTHON CONVENTIONS
#vvvvvvvvvvvvvvvvvvvvv


# LINE LENGTH
#
# Limit all lines to a maximum of 79 characters.
# For flowing long blocks of text with fewer structural restrictions (docstrings
# or comments), the line length should be limited to 72 characters. 
#
# The preferred way of wrapping long lines is by using Python's implied line
# continuation inside parentheses, brackets and braces. Long lines can be broken
# over multiple lines by wrapping expressions in parentheses. These should be
# used in preference to using a backslash for line continuation.
# Backslashes may still be appropriate at times. For example, long, multiple with
# -statements cannot use implicit continuation, so backslashes are acceptable: 

# BLACK LINES
#
# Surround top-level function and class definitions with two blank lines.
#
# Method definitions inside a class are surrounded by a single blank line. 

# IMPORTS
#
# Imports should usually be on separate lines
#
# Imports are always put at the top of the file, just after any module comments
# and docstrings, and before module globals and constants. 
#
# Order: 
# standard library imports > related third party imports > local
# application/library specific imports 
#
# You should put a blank line between each group of import

# STRINGS
#
# For triple-quoted strings, always use double quote characters
#

# WHITESPACE
#
# If operators with different priorities are used, consider adding whitespace
# around the operators with the lowest priority(ies). Use your own judgment;
# however, never use more than one space, and always have the same amount of
# whitespace on both sides of a binary operator. 
# *dont* use spaces around the = sign when used to indicate a keyword argument
# or a default parameter value. 


# COMMENTS (how meta?)
#
# Comments should be complete sentences. If a comment is a phrase or sentence,
# *its first word should be capitalized*, unless it is an identifier that begins
# with a lower case letter (never alter the case of identifiers!). 
#
# Use inline comments sparingly. 

# DOCUMENTATION STRINGS
#
# Write docstrings for all public modules, functions, classes, and methods.
# Docstrings are not necessary for non-public methods, but you should have a
# comment that describes what the method does. This comment should appear after
# the def line. 

# NAMING CONVENTIONS 
# 
# (_blah) use the underscore before the actual name of a function if you
# normally don't want the user to use this but rather want it to be accessed by
# other functions only - internal use
#
# (blah_) used by convention to avoid conflicts with Python keyword 
#
# Never use the characters 'l' (lowercase letter el), 'O' (uppercase letter oh),
# or 'I' (uppercase letter eye) as single character variable names. 
#
# Class names should normally use the CapWords convention. 
# (Exceptions) Because exceptions should be classes, the class naming convention
# applies here (ValueError, IndexError etc.
#
# ***Modules that are designed for use via from M import * should use the
# __all__ mechanism*** to prevent exporting globals, or use the older convention of
# prefixing such globals with an underscore
#
# Function names should be lowercase, with words separated by underscores as
# necessary to improve readability
#
# Constants are usually defined on a module level and written in all capital
# letters with underscores separating words. Examples include MAX_OVERFLOW and
# TOTAL .
#
# If your class is intended to be subclassed, and you have attributes that you
# do not want subclasses to use, consider naming them with double leading
# underscores and no trailing underscores. This invokes Python's name mangling
# algorithm, where the name of the class is mangled into the attribute name.

 
# GENERAL RECCOMENDATIONS 
# 
# In performance sensitive parts of the library, the ''.join() form should be
# used instead. This will ensure that concatenation occurs in linear time across
# various implementations
#
# beware of writing if x when you really mean if x is not None
#
# Use is not operator rather than not ... is 
# Always use a def statement instead of an assignment statement that binds a
# lambda expression directly to an identifier
#
# Derive exceptions from Exception rather than BaseException
# Aim to answer the question "What went wrong?" programmatically, rather than
# only stating that "A problem occurred
#
# When raising an exception in Python 2, use raise ValueError('message')
#
# When catching exceptions, mention specific exceptions whenever possible
# instead of using a bare except:
# A bare except: clause will catch SystemExit and KeyboardInterrupt exceptions,
# making it harder to interrupt a program with Control-C, and can disguise other
# problems. If you want to catch all exceptions that signal program errors, use
# except Exception:
#
# When binding caught exceptions to a name, prefer the explicit name binding
# syntax added in Python 2.6: 
#   try:
#      process_data()
#   except Exception as exc:
#      raise DataProcessingFailedError(str(exc)) # Python3 compatible syntax!
# 
#  If any return statement returns an expression, any return statements where no
#  value is returned should explicitly state this as return None
# 
# Use ''.startswith() and ''.endswith() instead of string slicing to check for
# prefixes or suffixes. 
# 
# Object type comparisons should always use isinstance() instead of comparing
# types directly. 
#   Yes: if isinstance(obj, int):
#   No:  if type(obj) is type(1)
# 
# For sequences, (strings, lists, tuples), use the fact that empty sequences are
# false.
#
# 

#^^^^^^^^^^^^^^^^^^^^

# QUEUES \ PIPES
####################
# Queues have synchronization capabilities, threads have to access them in turns
# The big win is that queues are process- and thread- safe. Pipes are not:
# Queues are faster


###############################################################################



#!/usr/bin/env python
# -*- coding: utf-8 -*-

# concatenate unicode - ascii strings
unicode_string + "kalimera".encode('utf8')

# matplotlib - change background color
ax.set_axis_bgcolor([i / 253. for i in [123, 203, 252]])


# get ip by the name of the host
socket.gethostbyname(socket.gethostname())


# timestamp
datetime.date.today().isoformat()
print str(now)
str(now).split('.')[0]
now = datetime.datetime.now()
print "Current date and time using strftime:"
print now.strftime("%Y-%m-%d %H:%M")
print
print "Current date and time using isoformat:"
print now.isoformat()
