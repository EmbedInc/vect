{
*  This module contains all the bounce routines used by FORTRAN for communicating
*  with the vect library.
}
module vect_ftn_bounce;
define vect_ftn_3x3_exp_from_ ;
define vect_ftn_3x3_exp_to_ ;
%include 'sys.ins.pas';
%include 'sys_ftn.ins.pas';
%include 'vect.ins.pas';

type
  exp3x3_t = array[1..15] of sys_ftn_real_t;
  mat3x3_t = array[1..9] of sys_ftn_real_t;


procedure vect_ftn_3x3_exp_from_ (     {make 3x3 matrix from expanded representation}
  in      ex: exp3x3_t;                {expanded representation of matrix}
  out     mat: mat3x3_t);              {resulting 3x3 transformation matrix}
  extern;

procedure vect_ftn_3x3_exp_to_ (       {make expanded form of a 3x3 matrix}
  in      mat: mat3x3_t;               {3x3 transformation matrix to expand}
  out     ex: exp3x3_t;                {expanded representation}
  out     err: sys_ftn_logical_t);     {TRUE if conversion was not possible}
  extern;

{*************************************}

procedure vect_ftn_3x3_exp_from_ (     {make 3x3 matrix from expanded representation}
  in      ex: exp3x3_t;                {expanded representation of matrix}
  out     mat: mat3x3_t);              {resulting 3x3 transformation matrix}

var
  exp3x3: vect_exp3x3_t;
  mat3x3: vect_mat3x3_t;
  err: vect_experr_t;

begin
  exp3x3.rot_xb.x := ex[1];
  exp3x3.rot_xb.y := ex[2];
  exp3x3.rot_xb.z := ex[3];

  exp3x3.rot_yb.x := ex[4];
  exp3x3.rot_yb.y := ex[5];
  exp3x3.rot_yb.z := ex[6];

  exp3x3.skew_yb.x := ex[7];
  exp3x3.skew_yb.y := ex[8];
  exp3x3.skew_yb.z := ex[9];

  exp3x3.skew_zb.x := ex[10];
  exp3x3.skew_zb.y := ex[11];
  exp3x3.skew_zb.z := ex[12];

  exp3x3.scale_x := ex[13];
  exp3x3.scale_y := ex[14];
  exp3x3.scale_z := ex[15];

  vect_3x3_exp_from (exp3x3, mat3x3, err);

  mat[1] := mat3x3.xb.x;
  mat[2] := mat3x3.xb.y;
  mat[3] := mat3x3.xb.z;

  mat[4] := mat3x3.yb.x;
  mat[5] := mat3x3.yb.y;
  mat[6] := mat3x3.yb.z;

  mat[7] := mat3x3.zb.x;
  mat[8] := mat3x3.zb.y;
  mat[9] := mat3x3.zb.z;
  end;

{*************************************}

procedure vect_ftn_3x3_exp_to_ (       {make expanded form of a 3x3 matrix}
  in      mat: mat3x3_t;               {3x3 transformation matrix to expand}
  out     ex: exp3x3_t;                {expanded representation}
  out     err: sys_ftn_logical_t);     {TRUE if conversion was not possible}

var
  exp3x3: vect_exp3x3_t;
  mat3x3: vect_mat3x3_t;
  i_err: boolean;

begin
  mat3x3.xb.x := mat[1];
  mat3x3.xb.y := mat[2];
  mat3x3.xb.z := mat[3];

  mat3x3.yb.x := mat[4];
  mat3x3.yb.y := mat[5];
  mat3x3.yb.z := mat[6];

  mat3x3.zb.x := mat[7];
  mat3x3.zb.y := mat[8];
  mat3x3.zb.z := mat[9];

  vect_3x3_exp_to (mat3x3, exp3x3, i_err);

  err := sys_pas_boolean_t_ftn_logical (i_err);

  ex[1] := exp3x3.rot_xb.x;
  ex[2] := exp3x3.rot_xb.y;
  ex[3] := exp3x3.rot_xb.z;

  ex[4] := exp3x3.rot_yb.x;
  ex[5] := exp3x3.rot_yb.y;
  ex[6] := exp3x3.rot_yb.z;

  ex[7] := exp3x3.skew_yb.x;
  ex[8] := exp3x3.skew_yb.y;
  ex[9] := exp3x3.skew_yb.z;

  ex[10] := exp3x3.skew_zb.x;
  ex[11] := exp3x3.skew_zb.y;
  ex[12] := exp3x3.skew_zb.z;

  ex[13] := exp3x3.scale_x;
  ex[14] := exp3x3.scale_y;
  ex[15] := exp3x3.scale_z;
  end;
