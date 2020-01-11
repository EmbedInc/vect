{   Subroutine VECT_3X3_EXP_FROM (EX,MAT,ERR)
*
*   Construct the 3x3 transformation matrix MAT from its expanded form EX.
*   ERR is a returned set of error flags.  Errors can ocurr if one of the
*   vectors of the skew or rotation component are zero.
*
*   The expanded form contains separate scale, rotation, and skew component.
*   The reconstruction can be thought of as matrix multiplies of
*   SKEW x ROTATION x SCALE.  This is basically what's done, except that each
*   of the three components are not stored as complete 3x3 matricies because
*   some of the terms would be either constant or redundant.  Also, due to
*   interpolation, the vectors may not be all orthogonal or unitized where
*   they should be.
}
module vect_3X3_EXP_FROM;
define vect_3x3_exp_from;
%include 'vect2.ins.pas';

procedure vect_3x3_exp_from (          {make 3x3 matrix from expanded representation}
  in      ex: vect_exp3x3_t;           {expanded representation of matrix}
  out     mat: vect_mat3x3_t;          {resulting 3x3 transformation matrix}
  out     err: vect_experr_t);         {returned error flags}

var
  skewy, skewz: vect_3d_t;             {sanitized skew component}
  rotx, roty, rotz: vect_3d_t;         {sanitized rotation component}
  m: real;                             {mult factor for unitizing vectors}

label
  skew_bad, done_skew, rot_bad, done_rot;

begin
  err := [];                           {init to no error condition}
{
*   Make sanitized skew matrix.  The X basis vector of this matrix is
*   always 1,0,0, so we won't store it.
}
  m := sqrt(
    sqr(ex.skew_yb.x) + sqr(ex.skew_yb.y) + sqr(ex.skew_yb.z));
  if m < 1.0E-20 then goto skew_bad;
  m := 1.0 / m;                        {make mult factor to unitize vector}
  skewy.x := ex.skew_yb.x * m;
  skewy.y := ex.skew_yb.y * m;
  skewy.z := ex.skew_yb.z * m;

  m := sqrt(
    sqr(ex.skew_zb.x) + sqr(ex.skew_zb.y) + sqr(ex.skew_zb.z));
  if m < 1.0E-20 then goto skew_bad;
  m := 1.0 / m;                        {make mult factor to unitize vector}
  skewz.x := ex.skew_zb.x * m;
  skewz.y := ex.skew_zb.y * m;
  skewz.z := ex.skew_zb.z * m;

done_skew:                             {done making sanitized skew matrix}
{
*  Make sanitized rotation matrix.
}
  m := sqrt(                           {sanitize rotation XB}
    sqr(ex.rot_xb.x) + sqr(ex.rot_xb.y) + sqr(ex.rot_xb.z));
  if m < 1.0E-20 then goto rot_bad;
  m := 1.0 / m;                        {make mult factor to unitize vector}
  rotx.x := ex.rot_xb.x * m;
  rotx.y := ex.rot_xb.y * m;
  rotx.z := ex.rot_xb.z * m;

  rotz.x := (rotx.y * ex.rot_yb.z) - (rotx.z * ex.rot_yb.y); {direction for rot ZB}
  rotz.y := (rotx.z * ex.rot_yb.x) - (rotx.x * ex.rot_yb.z);
  rotz.z := (rotx.x * ex.rot_yb.y) - (rotx.y * ex.rot_yb.x);
  m := sqrt(                           {unitize rotation ZB}
    sqr(rotz.x) + sqr(rotz.y) + sqr(rotz.z));
  if m < 1.0E-20 then goto rot_bad;
  m := 1.0 / m;                        {make mult factor to unitize vector}
  rotz.x := rotz.x * m;
  rotz.y := rotz.y * m;
  rotz.z := rotz.z * m;

  roty.x := (rotz.y * rotx.z) - (rotz.z * rotx.y); {YB is ZB cross XB}
  roty.y := (rotz.z * rotx.x) - (rotz.x * rotx.z);
  roty.z := (rotz.x * rotx.y) - (rotz.y * rotx.x);

done_rot:                              {done making sanitized rotation matrix}
{
*   The skew and rotation components have been sanitized.  Now combine the sanitized
*   components to form the final matrix in MAT.
}
  if err <> [] then return;            {can't make final matrix ?}

  mat.xb.x := ex.scale_x * rotx.x;
  mat.xb.y := ex.scale_x * rotx.y;
  mat.xb.z := ex.scale_x * rotx.z;

  mat.yb.x := ex.scale_y * (
    (skewy.x * rotx.x) + (skewy.y * roty.x) + (skewy.z * rotz.x));
  mat.yb.y := ex.scale_y * (
    (skewy.x * rotx.y) + (skewy.y * roty.y) + (skewy.z * rotz.y));
  mat.yb.z := ex.scale_y * (
    (skewy.x * rotx.z) + (skewy.y * roty.z) + (skewy.z * rotz.z));

  mat.zb.x := ex.scale_z * (
    (skewz.x * rotx.x) + (skewz.y * roty.x) + (skewz.z * rotz.x));
  mat.zb.y := ex.scale_z * (
    (skewz.x * rotx.y) + (skewz.y * roty.y) + (skewz.z * rotz.y));
  mat.zb.z := ex.scale_z * (
    (skewz.x * rotx.z) + (skewz.y * roty.z) + (skewz.z * rotz.z));
  return;                              {return with no error}

skew_bad:                              {one of the skew vectors is zero length}
  err := err + [vect_uxperr_skew_k];
  goto done_skew;

rot_bad:                               {one of the rotation vectors is zero length}
  err := err + [vect_uxperr_rot_k];
  goto done_rot;
  end;
