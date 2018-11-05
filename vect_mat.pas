{   Module of routines that perform manipulations on 3x3 and 3x4 transformation
*   matricies.
}
module vect_mat;
define vect_3x3_invert;
define vect_3x4_invert;
define vect_xf3x3;
define vect_xf3x4;
define vect_m3x3_mult;
define vect_m3x4_mult;
define vect_m3x4_rotate_x;
define vect_m3x4_rotate_y;
define vect_m3x4_rotate_z;
%include '/cognivision_links/dsee_libs/vect/vect2.ins.pas';
{
****************************************************
}
procedure vect_3x3_invert (            {compute inverse of 3x3 transformation matrix}
  in      fwd: vect_mat3x3_t;          {input 3x3 transformation matrix}
  out     vol: real;                   {volume (determinant) of input matrix}
  out     bak_exists: boolean;         {TRUE if inverse exists}
  out     bak: vect_mat3x3_t);         {will be inverse of FWD}

var
  xb, yb, zb: vect_3d_t;               {temporary scratch xform matrix}
  m: real;                             {scale factor}

begin
{
*   Make the unscaled inverse transpose.  Each vector in this matrix is the
*   cross product of the original versions of the other two.
}
  xb.x := fwd.yb.y*fwd.zb.z - fwd.yb.z*fwd.zb.y;
  xb.y := fwd.yb.z*fwd.zb.x - fwd.yb.x*fwd.zb.z;
  xb.z := fwd.yb.x*fwd.zb.y - fwd.yb.y*fwd.zb.x;

  yb.x := fwd.zb.y*fwd.xb.z - fwd.zb.z*fwd.xb.y;
  yb.y := fwd.zb.z*fwd.xb.x - fwd.zb.x*fwd.xb.z;
  yb.z := fwd.zb.x*fwd.xb.y - fwd.zb.y*fwd.xb.x;

  zb.x := fwd.xb.y*fwd.yb.z - fwd.xb.z*fwd.yb.y;
  zb.y := fwd.xb.z*fwd.yb.x - fwd.xb.x*fwd.yb.z;
  zb.z := fwd.xb.x*fwd.yb.y - fwd.xb.y*fwd.yb.x;

  vol :=                               {volume (determinant) of orignal matrix}
    (fwd.zb.x * zb.x) +
    (fwd.zb.y * zb.y) +
    (fwd.zb.z * zb.z);

  if abs(vol) > 1.0E-30
    then begin                         {inverse of FWD matrix exists}
      bak_exists := true;
      m := 1.0 / vol;                  {make scale factor for final matrix}
      bak.xb.x := xb.x * m;            {scale correctly and make transpose}
      bak.xb.y := yb.x * m;
      bak.xb.z := zb.x * m;
      bak.yb.x := xb.y * m;
      bak.yb.y := yb.y * m;
      bak.yb.z := zb.y * m;
      bak.zb.x := xb.z * m;
      bak.zb.y := yb.z * m;
      bak.zb.z := zb.z * m;
      end
    else begin                         {inverse does not exist}
      bak_exists := false;
      end
    ;
  end;
{
****************************************************
}
function vect_3x4_invert (             {compute inverse of 3x4 transformation matrix}
  in      fwd: vect_mat3x4_t;          {input 3x4 transformation matrix}
  out     bak: vect_mat3x4_t)          {will be inverse of FWD}
  :boolean;                            {TRUE if inverse exists}

var
  m: vect_mat3x4_t;                    {scratch matrix}
  vol: real;                           {unused matrix volume}
  bak_exists: boolean;                 {TRUE if inverse exists}

begin
  vect_3x3_invert (fwd.m33, vol, bak_exists, m.m33); {invert 3x3 part of matrix}
  if not bak_exists then begin         {inverse doesn't exist ?}
    vect_3x4_invert := false;
    return;
    end;
{
*   The inverted matrix's offset vector is set so that the forward matrix's
*   offset vector transformed thru the inverse matrix results in the origin.
}
  m.ofs.x := -(                        {set offset vector of inverse matrix}
    fwd.ofs.x * m.m33.xb.x +
    fwd.ofs.y * m.m33.yb.x +
    fwd.ofs.z * m.m33.zb.x);
  m.ofs.y := -(
    fwd.ofs.x * m.m33.xb.y +
    fwd.ofs.y * m.m33.yb.y +
    fwd.ofs.z * m.m33.zb.y);
  m.ofs.z := -(
    fwd.ofs.x * m.m33.xb.z +
    fwd.ofs.y * m.m33.yb.z +
    fwd.ofs.z * m.m33.zb.z);
  bak := m;                            {pass back inverted 3x4 matrix}
  vect_3x4_invert := true;             {inverse did exist}
  end;
{
****************************************************
}
function vect_xf3x3 (                  {transform coordinate thru 3x3 matrix}
  in      p: vect_3d_t;                {input coordinate}
  in      m: vect_mat3x3_t)            {transformation matrix}
  :vect_3d_t;                          {transformed coordinate}
  val_param;

var
  q: vect_3d_t;

begin
  q.x := (p.x * m.xb.x) + (p.y * m.yb.x) + (p.z * m.zb.x);
  q.y := (p.x * m.xb.y) + (p.y * m.yb.y) + (p.z * m.zb.y);
  q.z := (p.x * m.xb.z) + (p.y * m.yb.z) + (p.z * m.zb.z);
  vect_xf3x3 := q;
  end;
{
****************************************************
}
function vect_xf3x4 (                  {transform coordinate thru 3x4 matrix}
  in      p: vect_3d_t;                {input coordinate}
  in      m: vect_mat3x4_t)            {transformation matrix}
  :vect_3d_t;                          {transformed coordinate}
  val_param;

var
  q: vect_3d_t;

begin
  q.x := (p.x * m.m33.xb.x) + (p.y * m.m33.yb.x) + (p.z * m.m33.zb.x) + m.ofs.x;
  q.y := (p.x * m.m33.xb.y) + (p.y * m.m33.yb.y) + (p.z * m.m33.zb.y) + m.ofs.y;
  q.z := (p.x * m.m33.xb.z) + (p.y * m.m33.yb.z) + (p.z * m.m33.zb.z) + m.ofs.z;
  vect_xf3x4 := q;
  end;
{
****************************************************
}
function vect_m3x3_mult (              {multiply two 3x3 matricies}
  in      m1: vect_mat3x3_t;           {first input matrix}
  in      m2: vect_mat3x3_t)           {second input matrix}
  :vect_mat3x3_t;                      {result of M1 x M2}
  val_param;

var
  m3: vect_mat3x3_t;

begin
  m3.xb := vect_xf3x3 (m1.xb, m2);
  m3.yb := vect_xf3x3 (m1.yb, m2);
  m3.zb := vect_xf3x3 (m1.zb, m2);
  vect_m3x3_mult := m3;
  end;
{
****************************************************
}
function vect_m3x4_mult (              {multiply two 3x4 matricies}
  in      m1: vect_mat3x4_t;           {first input matrix}
  in      m2: vect_mat3x4_t)           {second input matrix}
  :vect_mat3x4_t;                      {result of M1 x M2}
  val_param;

var
  m3: vect_mat3x4_t;

begin
  m3.m33.xb := vect_xf3x3 (m1.m33.xb, m2.m33);
  m3.m33.yb := vect_xf3x3 (m1.m33.yb, m2.m33);
  m3.m33.zb := vect_xf3x3 (m1.m33.zb, m2.m33);
  m3.ofs := vect_xf3x4 (m1.ofs, m2);
  vect_m3x4_mult := m3;
  end;
{
****************************************************
}
function vect_m3x4_rotate_x (          {make 3x4 matrix for rotation around X axis}
  in      a: real)                     {rotation angle in radians}
  :vect_mat3x4_t;                      {returned rotation matrix}
  val_param;

var
  c, s: real;                          {SIN and COS of input angle}

begin
  c := cos(a);                         {save SIN and COS of input angle}
  s := sin(a);

  vect_m3x4_rotate_x.m33.xb.x := 1.0;
  vect_m3x4_rotate_x.m33.xb.y := 0.0;
  vect_m3x4_rotate_x.m33.xb.z := 0.0;

  vect_m3x4_rotate_x.m33.yb.x := 0.0;
  vect_m3x4_rotate_x.m33.yb.y := c;
  vect_m3x4_rotate_x.m33.yb.z := s;

  vect_m3x4_rotate_x.m33.zb.x := 0.0;
  vect_m3x4_rotate_x.m33.zb.y := -s;
  vect_m3x4_rotate_x.m33.zb.z := c;

  vect_m3x4_rotate_x.ofs.x := 0.0;
  vect_m3x4_rotate_x.ofs.y := 0.0;
  vect_m3x4_rotate_x.ofs.z := 0.0;
  end;
{
****************************************************
}
function vect_m3x4_rotate_y (          {make 3x4 matrix for rotation around Y axis}
  in      a: real)                     {rotation angle in radians}
  :vect_mat3x4_t;                      {returned rotation matrix}
  val_param;

var
  c, s: real;                          {SIN and COS of input angle}

begin
  c := cos(a);                         {save SIN and COS of input angle}
  s := sin(a);

  vect_m3x4_rotate_y.m33.xb.x := c;
  vect_m3x4_rotate_y.m33.xb.y := 0.0;
  vect_m3x4_rotate_y.m33.xb.z := -s;

  vect_m3x4_rotate_y.m33.yb.x := 0.0;
  vect_m3x4_rotate_y.m33.yb.y := 1.0;
  vect_m3x4_rotate_y.m33.yb.z := 0.0;

  vect_m3x4_rotate_y.m33.zb.x := s;
  vect_m3x4_rotate_y.m33.zb.y := 0.0;
  vect_m3x4_rotate_y.m33.zb.z := c;

  vect_m3x4_rotate_y.ofs.x := 0.0;
  vect_m3x4_rotate_y.ofs.y := 0.0;
  vect_m3x4_rotate_y.ofs.z := 0.0;
  end;
{
****************************************************
}
function vect_m3x4_rotate_z (          {make 3x4 matrix for rotation around Z axis}
  in      a: real)                     {rotation angle in radians}
  :vect_mat3x4_t;                      {returned rotation matrix}
  val_param;

var
  c, s: real;                          {SIN and COS of input angle}

begin
  c := cos(a);                         {save SIN and COS of input angle}
  s := sin(a);

  vect_m3x4_rotate_z.m33.xb.x := c;
  vect_m3x4_rotate_z.m33.xb.y := s;
  vect_m3x4_rotate_z.m33.xb.z := 0.0;

  vect_m3x4_rotate_z.m33.yb.x := -s;
  vect_m3x4_rotate_z.m33.yb.y := c;
  vect_m3x4_rotate_z.m33.yb.z := 0.0;

  vect_m3x4_rotate_z.m33.zb.x := 0.0;
  vect_m3x4_rotate_z.m33.zb.y := 0.0;
  vect_m3x4_rotate_z.m33.zb.z := 1.0;

  vect_m3x4_rotate_z.ofs.x := 0.0;
  vect_m3x4_rotate_z.ofs.y := 0.0;
  vect_m3x4_rotate_z.ofs.z := 0.0;
  end;
