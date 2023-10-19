{   Small routines that operate on 2D points and vectors.
}
module vect_2d;
define vect_2d_unitize;
%include 'vect2.ins.pas';
{
********************************************************************************
*
*   Subroutine VECT_2D_UNITIZE (V)
*
*   Adjust the length of the 2D vector V to be 1.  The direction is preserved.
*   If V is too small to reliably determine its direction, then an arbitrary
*   unit vector is returned.
}
procedure vect_2d_unitize (            {unitize a 2D vector}
  in out  v: vect_2d_t);               {will be returned unit length}
  val_param;

var
  m: real;

begin
  m := sqrt(sqr(v.x) + sqr(v.y));      {make magnitude}
  if m < 1.0e-32 then begin            {too small, return arbitrary unit vect ?}
    v.x := 1.0;
    v.y := 0.0;
    return;
    end;

  v.x := v.x / m;                      {adjust the magnitude to 1}
  v.y := v.y / m;
  end;
