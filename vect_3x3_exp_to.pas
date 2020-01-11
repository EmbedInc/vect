{   Subroutine VECT_3X3_EXP_TO (MAT,EX,ERR)
*
*   Create expanded form in EX of the 3x3 transformation matrix MAT.
*   The individual values in the expanded form may be linearly combined with
*   those from other expanded matricies to interpolate between transforms.
*   After interpolation, the expanded form can be converted back to a 3x3 matrix
*   with subroutine VECT_3X3_EXP_FROM.  If the expansion was not possible, then
*   OK is set to FALSE, and EX is undefined.  If the expansion was possible, then
*   OK is set to TRUE, and EX is properly filled in.  The expansion is not possible
*   if any of the basis vectors are of zero length, or all three basis vectors
*   are in the same plane.
}
module vect_3X3_EXP_TO;
define vect_3x3_exp_to;
%include 'vect2.ins.pas';

procedure vect_3x3_exp_to (            {make expanded form of a 3x3 matrix}
  in      mat: vect_mat3x3_t;          {3x3 transformation matrix to expand}
  out     ex: vect_exp3x3_t;           {expanded representation}
  out     err: boolean);               {TRUE if conversion was not possible}

var
  xb, yb, zb: vect_3d_t;               {"remaining" matrix as components are removed}
  m: real;                             {mult factor for adjusting vector length}
  inv: vect_mat3x3_t;                  {inverse of extracted rotation component}

begin
  err := true;                         {init to conversion not possible}
{
*   Find basis vector scale factors.
}
  ex.scale_x := sqrt(
    sqr(mat.xb.x) + sqr(mat.xb.y) + sqr(mat.xb.z));
  ex.scale_y := sqrt(
    sqr(mat.yb.x) + sqr(mat.yb.y) + sqr(mat.yb.z));
  ex.scale_z := sqrt(
    sqr(mat.zb.x) + sqr(mat.zb.y) + sqr(mat.zb.z));
{
*   Remove scale factors and put resulting matrix in XB, YB, ZB.  The Z scale
*   factor is flipped if the original matrix was left handed.
}
  if                                   {no expansion possible ?}
      (ex.scale_x < 1.0E-20) or
      (ex.scale_y < 1.0E-20) or
      (ex.scale_z < 1.0E-20)
    then return;

  m := 1.0 / ex.scale_x;               {make mult factor for XB}
  xb.x := mat.xb.x * m;                {remove scale factor from XB}
  xb.y := mat.xb.y * m;
  xb.z := mat.xb.z * m;

  m := 1.0 / ex.scale_y;               {make mult factor for YB}
  yb.x := mat.yb.x * m;                {remove scale factor from YB}
  yb.y := mat.yb.y * m;
  yb.z := mat.yb.z * m;

  if                                   {original matrix was left handed ?}
      (((xb.y*yb.z - xb.z*yb.y) * mat.zb.x) +
       ((xb.z*yb.x - xb.x*yb.z) * mat.zb.y) +
       ((xb.x*yb.y - xb.y*yb.x) * mat.zb.z)) < 0.0
    then ex.scale_z := -ex.scale_z;    {flip sign of Z scale factor}

  m := 1.0 / ex.scale_z;               {make mult factor for ZB}
  zb.x := mat.zb.x * m;                {remove scale factor from ZB}
  zb.y := mat.zb.y * m;
  zb.z := mat.zb.z * m;
{
*   The local matrix XB,YB,ZB has the scale factors extracted.  That means that
*   it is definately right handed and all its basis vectors are of unit length.
*   Now extract the rotation component.
}
  ex.rot_yb.x := (zb.y * xb.z) - (zb.z * xb.y); {raw YB of rotation matrix}
  ex.rot_yb.y := (zb.z * xb.x) - (zb.x * xb.z);
  ex.rot_yb.z := (zb.x * xb.y) - (zb.y * xb.x);

  m := sqrt(                           {magnitude of raw YB of pure rotation matrix}
    sqr(ex.rot_yb.x) + sqr(ex.rot_yb.y) + sqr(ex.rot_yb.z));
  if m < 1.0E-20 then return;          {not possible to unitize this vector ?}
  m := 1.0 / m;                        {make mult factor for unitizing}
  ex.rot_yb.x := ex.rot_yb.x * m;      {unitize YB of pure rotation martix}
  ex.rot_yb.y := ex.rot_yb.y * m;
  ex.rot_yb.z := ex.rot_yb.z * m;
  ex.rot_xb.x := xb.x;                 {save XB of pure rotation matrix}
  ex.rot_xb.y := xb.y;
  ex.rot_xb.z := xb.z;
{
*   The raw rotation component has been saved in EX.  The rotation now needs to
*   be "removed" from the matrix XB,YB,ZB to yeild the skew matrix.  This is
*   done by finding the inverse of the raw rotation.  This inverse is just the
*   transpose, since the rotation matrix is all orthogonal vectors of unit length.
*   The inverse will be put into INV.  The Z basis vector of the rotation matrix
*   is not lying around, and needs to be calculated from XB cross YB.
}
  inv.xb.x := ex.rot_xb.x;
  inv.yb.x := ex.rot_xb.y;
  inv.zb.x := ex.rot_xb.z;

  inv.xb.y := ex.rot_yb.x;
  inv.yb.y := ex.rot_yb.y;
  inv.zb.y := ex.rot_yb.z;

  inv.xb.z := (ex.rot_xb.y * ex.rot_yb.z) - (ex.rot_xb.z * ex.rot_yb.y);
  inv.yb.z := (ex.rot_xb.z * ex.rot_yb.x) - (ex.rot_xb.x * ex.rot_yb.z);
  inv.zb.z := (ex.rot_xb.x * ex.rot_yb.y) - (ex.rot_xb.y * ex.rot_yb.x);
{
*   INV now contains the inverse of the rotation component already in EX.
*   Use this inverse to "remove" the rotation component from the matrix.
*   The result becomes the skew component.  This is written directly into
*   EX.  Note that only the Y and Z basis vectors of the skew component are
*   saved since the X component is always 1,0,0.
}
  ex.skew_yb.x := (yb.x * inv.xb.x) + (yb.y * inv.yb.x) + (yb.z * inv.zb.x);
  ex.skew_yb.y := (yb.x * inv.xb.y) + (yb.y * inv.yb.y) + (yb.z * inv.zb.y);
  ex.skew_yb.z := (yb.x * inv.xb.z) + (yb.y * inv.yb.z) + (yb.z * inv.zb.z);

  ex.skew_zb.x := (zb.x * inv.xb.x) + (zb.y * inv.yb.x) + (zb.z * inv.zb.x);
  ex.skew_zb.y := (zb.x * inv.xb.y) + (zb.y * inv.yb.y) + (zb.z * inv.zb.y);
  ex.skew_zb.z := (zb.x * inv.xb.z) + (zb.y * inv.yb.z) + (zb.z * inv.zb.z);

  err := false;                        {conversion was performed}
  end;
