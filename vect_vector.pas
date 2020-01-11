{   Function VECT_VECTOR (X,Y,Z)
*
*   Return the vector built from the three scalars X, Y, and Z.
}
module vect_vector;
define vect_vector;
%include 'vect2.ins.pas';

function vect_vector (                 {build a vector from 3 scalars}
  in      x: real;                     {X coor of vector}
  in      y: real;                     {Y coor of vector}
  in      Z: real)                     {Z coor of vector}
  :vect_3d_t;                          {resulting vector}

begin
  vect_vector.x := x;
  vect_vector.y := y;
  vect_vector.z := z;
  end;
