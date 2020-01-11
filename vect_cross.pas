{   Function VECT_CROSS (V1,V2)
*
*   Return the vector cross product V1 x V2.
}
module vect_cross;
define vect_cross;
%include 'vect2.ins.pas';

function vect_cross (                  {take a cross product of two vectors}
  in      v1: vect_3d_t;               {first input vector of cross product}
  in      v2: vect_3d_t)               {second input vector of cross product}
  :vect_3d_t;                          {resulting cross product}

begin
  vect_cross.x := v1.y*v2.z - v1.z*v2.y;
  vect_cross.y := v1.z*v2.x - v1.x*v2.z;
  vect_cross.z := v1.x*v2.y - v1.y*v2.x;
  end;
