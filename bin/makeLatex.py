#!/usr/bin/env python
# -*- coding: UTF-8 -*-

"""
DOCUMENTATION: 
    The following is a python module for automating the procedure of compiling
    a latex project. 

    The project is divided in the following folders:

    texfiles:
        folder for storing *links* to the .tex files written by the user
    draft: 
        folder for storing the files geneerated from the latex compilation
        procedure. (*.nlo, *.toc, ...)
        The actual .tex fiels are kept here as well
    figures:
        folders storing the figures used in the latex project. Usually stores
        subfolders which hold the pictures for the various chapters.
    supplementary: 
        various tools, handy for verifying the written text and the compilation
        of the latex code


MODIFICATIONS:
    - make a universal log function -> see logging module
    - initialization python script for tree-structure
    - use utf-8 encoding
    - [!] use timestamps to notify user if he hasn't run this for a long time ..
      (so probably he is compiling for a previous project)
"""


# imports
import os
import sys
from subprocess import call
from sup_funs import print_, force_symlink


# booleans
output = 1 # ntoused yet. going to be used in the print_ function - todo
nomen_bib = 1

# tools to use
compiler = 'xelatex'

# file/folder names
main_tex = 'report.tex'
main_tex_plain = main_tex.split('.')[0]

msg = "Compilation process begins..."
print_(msg)

report_dir = "/Users/nick/template_example/"
template_dir = '/Users/nick/local/latex_extensions/template/'
 
if report_dir == template_dir:
    msg = "Please fill in the report diractory accordingly"
    msg += "(the default template directory is active)"
    msg += "\n\tExiting.."
    print_(msg)
    sys.exit()
init_dir = os.getcwd()

# Change to home folder
# #########
os.chdir(report_dir)


os.system('clear')
msg = "Compiler: {compiler}\n\tMain file: \
    {texFile}".format(compiler=compiler, texFile=main_tex)
print_(msg)


# COMPILATION PROCESS

print_('Compiling main file: {}\n\t 1st Time'.format(
       main_tex))
# compile the report tex file
os.chdir("".join([report_dir, 'drafts/']))
call([compiler, main_tex])
os.chdir(report_dir)

# INDEXING - BIBTEX PROPER COMPILATION

if nomen_bib:

    os.chdir("".join([report_dir, 'drafts/']))
    # Render the bibliography section
    print_("Making the bibliographic entries")
    call(['bibtex', main_tex_plain])
    call(['bibtex', main_tex_plain])

    # make the index
    makeindex_com = 'makeindex {0}.nlo -s nomencl.ist -o {0}.nls -t \
    {0}.nlg'.format(main_tex_plain)
    print_("Making the indexes: {time} time".format(time='1st'))
    os.system(makeindex_com)
    print_("Making the indexes: {time} time".format(time='2nd'))
    os.system(makeindex_com)

    print_('Compiling main file: {}\n\t 2nd Time'.format(main_tex))
    # compile the report tex file
    call([compiler, main_tex])
    os.chdir(report_dir)

# NEW SYMLINKS

# get list of texfiles
texfiles = [texfile for texfile in os.listdir('drafts/') if
            texfile.endswith('.tex') or texfile.endswith('.bib')]
texfiles_wpath = ["".join([report_dir, 'drafts/', texfile])
                  for texfile in texfiles]


msg = 'Making the .tex symlinks into {}'.format('texfiles/')
print_(msg)
for texfile_i in range(len(texfiles_wpath)):
    print("\tLinking {}".format(texfiles[texfile_i]))
    force_symlink(texfiles_wpath[texfile_i],
                  "".join(['texfiles/', texfiles[texfile_i]]))

# link the pdf file
force_symlink("".join([report_dir, 'drafts/', main_tex_plain, '.pdf']),
              "".join([report_dir, main_tex_plain, '.pdf']))


# EXITING ACTIONS

os.chdir(init_dir)
