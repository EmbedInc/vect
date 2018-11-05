{   Function VECT_ADD (V1,V2)
*
*   Return the vector sum V1 + V2.
}
module vect_add;
define vect_add;
%include '/cognivision_links/dsee_libs/vect/vect2.ins.pas';

function vect_add (                    {add two vectors}
  in      v1: vect_3d_t;               {input vector 1}
  in      v2: vect_3d_t)               {input vector 2}
  :vect_3d_t;                          {resulting vector sum}

begin
  vect_add.x := v1.x + v2.x;
  vect_add.y := v1.y + v2.y;
  vect_add.z := v1.z + v2.z;
  end;
