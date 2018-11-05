{   Function VECT_MAG (V)
*
*   Return the magnitude of vector V.
}
module vect_mag;
define vect_mag;
%include '/cognivision_links/dsee_libs/vect/vect2.ins.pas';

function vect_mag (                    {find magnitude of a vector}
  in      v: vect_3d_t)                {input vector}
  :real;                               {output magnitude}

begin
  vect_mag := sqrt(v.x*v.x + v.y*v.y + v.z*v.z);
  end;
