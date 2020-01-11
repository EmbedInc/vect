{   Subroutine VECT_ADJM (V,M)
*
*   Adjust the magnitude of vector V to be M.
}
module vect_adjm;
define vect_adjm;
%include 'vect2.ins.pas';

procedure vect_adjm (                  {adjust the magnitude of a vector}
  in out  v: vect_3d_t;                {vector to adjust magnitude of}
  in      m: real);                    {desired magnitude of vector}

var
  fact: real;                          {mult factor to adjust magnitude}

begin
  fact := m / sqrt(v.x*v.x + v.y*v.y + v.z*v.z); {adjustment factor}
  v.x := v.x * fact;                   {scale vector to new magnitude}
  v.y := v.y * fact;
  v.z := v.z * fact;
  end;
