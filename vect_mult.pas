{   Function VECT_MULT (V,M)
*
*   Return the vector V multiplied by the scalar M.
}
module vect_mult;
define vect_mult;
%include '/cognivision_links/dsee_libs/vect/vect2.ins.pas';

function vect_mult (                   {multiply a vector by a scalar}
  in      v: vect_3d_t;                {input vector}
  in      m: real)                     {mult factor}
  :vect_3d_t;                          {result of V*M}

begin
  vect_mult.x := v.x*m;
  vect_mult.y := v.y*m;
  vect_mult.z := v.z*m;
  end;
