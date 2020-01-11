{   Function VECT_SUB (V1,V2)
*
*   Return the vector difference V1 - V2.
}
module vect_sub;
define vect_sub;
%include 'vect2.ins.pas';

function vect_sub (                    {return subtraction of two vectors}
  in      v1: vect_3d_t;               {input vector to be subtracted from}
  in      v2: vect_3d_t)               {input vector to subtract from V1}
  :vect_3d_t;                          {result of V1-V2}

begin
  vect_sub.x := v1.x - v2.x;
  vect_sub.y := v1.y - v2.y;
  vect_sub.z := v1.z - v2.z;
  end;
