{   Function VECT_DOT (V1,V2)
*
*   Return the vector dot product of V1 dot V2.
}
module vect_dot;
define vect_dot;
%include '/cognivision_links/dsee_libs/vect/vect2.ins.pas';

function vect_dot (                    {find dot product of two vectors}
  in      v1: vect_3d_t;               {first input vector}
  in      v2: vect_3d_t)               {second input vector}
  :real;                               {resulting dot product value}

begin
  vect_dot := v1.x*v2.x + v1.y*v2.y + v1.z*v2.z;
  end;
