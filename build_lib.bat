@echo off
rem
rem   BUILD_LIB [-dbg]
rem
rem   Build the VECT library.
rem
setlocal
call build_pasinit

call src_insall %srcdir% %libname%

call src_pas %srcdir% %libname%_3x3_exp_from %1
call src_pas %srcdir% %libname%_3x3_exp_to %1
call src_pas %srcdir% %libname%_add %1
call src_pas %srcdir% %libname%_adjm %1
call src_pas %srcdir% %libname%_cross %1
call src_pas %srcdir% %libname%_dot %1
call src_pas %srcdir% %libname%_mag %1
call src_pas %srcdir% %libname%_mat %1
call src_pas %srcdir% %libname%_mult %1
call src_pas %srcdir% %libname%_sub %1
call src_pas %srcdir% %libname%_vector %1
call src_pas %srcdir% %libname%_xf2d %1

call src_lib %srcdir% %libname%
call src_msg %srcdir% %libname%
