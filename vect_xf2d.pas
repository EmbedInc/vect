{   Routines for manipulating and using 2D coordinate transforms.
}
module vect_xf2d;
define vect_xf2d_xfpnt;
define vect_xf2d_mult;
%include 'vect2.ins.pas';
{
********************************************************************************
*
*   Subroutine VECT_XF2D_XFPNT (X, Y, XF, P)
*
*   Transform the point X,Y thru the 2D transform XF, and return the result in
*   P.
}
procedure vect_xf2d_xfpnt (            {apply 2D transform to a point}
  in      x, y: real;                  {the input point}
  in      xf: vect_xf2d_t;             {the 2D transform to apply}
  out     p: vect_2d_t);               {resulting point}
  val_param;

begin
  p.x := (x * xf.xb.x) + (y * xf.yb.x) + xf.ofs.x;
  p.y := (x * xf.xb.y) + (y * xf.yb.y) + xf.ofs.y;
  end;
{
********************************************************************************
*
*   Subroutine VECT_XF2D_MULT (XFA, XFB, XFC)
*
*   Combine the 2D transforms XFA and XFB, in that order, and return the result
*   as the single transform XFC.  Tranforming a point thru XFC produces the same
*   result as if that point had been transformed thru XFA, then XFB.
}
procedure vect_xf2d_mult (             {combine two 2D transforms}
  in      xfa, xfb: vect_xf2d_t;       {the 2D transforms to combine, in order}
  out     xfc: vect_xf2d_t);           {the resulting combined transform}
  val_param;

begin
  xfc.xb.x := (xfa.xb.x * xfb.xb.x) + (xfa.xb.y * xfb.yb.x);
  xfc.xb.y := (xfa.xb.x * xfb.xb.y) + (xfa.xb.y * xfb.yb.y);

  xfc.yb.x := (xfa.yb.x * xfb.xb.x) + (xfa.yb.y * xfb.yb.x);
  xfc.yb.y := (xfa.yb.x * xfb.xb.y) + (xfa.yb.y * xfb.yb.y);

  xfc.ofs.x := (xfa.ofs.x * xfb.xb.x) + (xfa.ofs.y * xfb.yb.x) + xfb.ofs.x;
  xfc.ofs.y := (xfa.ofs.x * xfb.xb.y) + (xfa.ofs.y * xfb.yb.y) + xfb.ofs.y;
  end;
