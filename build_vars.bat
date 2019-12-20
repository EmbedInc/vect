@echo off
rem
rem   Define the variables for running builds from this source library.
rem
set srcdir=vect
set buildname=
call treename_var "(cog)source/vect" sourcedir
set libname=vect
set fwname=
call treename_var "(cog)src/%srcdir%/debug_%fwname%.bat" tnam
make_debug "%tnam%"
call "%tnam%"
