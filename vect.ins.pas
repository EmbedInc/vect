{   Include file to define data structures and entry points for the
*   VECT library.  This library manipulates vectors and matricies.
}
const
  vect_exp3x3_comps_k = 15;            {number of values in expanded 3x3 xform}

type
  vect_2d_p_t = ^vect_2d_t;
  vect_2d_t = record case integer of   {2D vector with array overlay}
    1:(                                {separate named fields}
      x: real;
      y: real);
    2:(                                {overlay array for arithmetic indexing}
      coor: array[1..2] of real);
    end;

  vect_3d_p_t = ^vect_3d_t;
  vect_3d_t = record case integer of   {3D vector with array overlay}
    1:(                                {separate named fields}
      x: real;
      y: real;
      z: real);
    2:(                                {overlay array for arithmetic indexing}
      coor: array[1..3] of real);
    end;

  vect_3d_fp1_p_t = ^vect_3d_fp1_t;
  vect_3d_fp1_t = record               {3D vector using single prec for compactness}
    x: single;
    y: single;
    z: single;
    end;

  vect_xf2d_p_t = ^vect_xf2d_t;
  vect_xf2d_t = record                 {2D coordinate transform}
    xb: vect_2d_t;                     {X basis vector}
    yb: vect_2d_t;                     {y basis vector}
    ofs: vect_2d_t;                    {offset to add after 2x2 multiply}
    end;

  vect_mat3x3_p_t = ^vect_mat3x3_t;
  vect_mat3x3_t = record               {3x3 transformation matrix}
    xb: vect_3d_t;                     {X basis vector}
    yb: vect_3d_t;                     {Y basis vector}
    zb: vect_3d_t;                     {Z basis vector}
    end;

  vect_mat3x4_p_t = ^vect_mat3x4_t;
  vect_mat3x4_t = record               {3x4 tranformation matrix}
    m33: vect_mat3x3_t;                {3x3 part of matrix}
    ofs: vect_3d_t;                    {offset vector}
    end;
{
*   "Expanded" 3x3 transform.  This data structure allows linear interpolation
*   between 3x3 matricies.  Each value in the expanded structure may be linearly
*   combined with another expanded transform to form a new expanded transform.
*   The result can be converted back to a 3x3 matrix.
}
  vect_uxperr_k_t = (                  {errors that can ocurr on matrix unexpansion}
    vect_uxperr_skew_k,                {skew component can not be unexpanded}
    vect_uxperr_rot_k);                {rotation component can not be unexpanded}

  vect_experr_t =                      {all the possible unexpand errors}
    set of vect_uxperr_k_t;

  vect_exp3x3_t = record               {expanded representation of 3x3 transform}
    case integer of
      1: (                             {separate named fields}
        rot_xb: vect_3d_t;             {X basis of rotation component}
        rot_yb: vect_3d_t;             {Y basis of rotation component}
        skew_yb: vect_3d_t;            {Y basis of skew component}
        skew_zb: vect_3d_t;            {Y basis of skew component}
        scale_x: real;                 {separate scale factors for each axis}
        scale_y: real;
        scale_z: real);
      2: (                             {pile of numbers for interpolating}
        comp:                          {all the components in one array}
          array [1..vect_exp3x3_comps_k] of real
        );
    end;
{
*   Entry point definitions.
}
procedure vect_2d_unitize (            {unitize a 2D vector}
  in out  v: vect_2d_t);               {will be returned unit length}
  val_param; extern;

procedure vect_3d_unitize (            {unitize a 3D vector}
  in out  v: vect_3d_t);               {will be returned unit length}
  val_param; extern;

procedure vect_3x3_exp_from (          {make 3x3 matrix from expanded representation}
  in      ex: vect_exp3x3_t;           {expanded representation of matrix}
  out     mat: vect_mat3x3_t;          {resulting 3x3 transformation matrix}
  out     err: vect_experr_t);         {returned error flags}
  extern;

procedure vect_3x3_exp_to (            {make expanded form of a 3x3 matrix}
  in      mat: vect_mat3x3_t;          {3x3 transformation matrix to expand}
  out     ex: vect_exp3x3_t;           {expanded representation}
  out     err: boolean);               {TRUE if conversion was not possible}
  extern;

procedure vect_3x3_invert (            {compute inverse of 3x3 transformation matrix}
  in      fwd: vect_mat3x3_t;          {input 3x3 transformation matrix}
  out     vol: real;                   {volume (determinant) of input matrix}
  out     bak_exists: boolean;         {TRUE if inverse exists}
  out     bak: vect_mat3x3_t);         {will be inverse of FWD}
  extern;

function vect_3x4_invert (             {compute inverse of 3x4 transformation matrix}
  in      fwd: vect_mat3x4_t;          {input 3x4 transformation matrix}
  out     bak: vect_mat3x4_t)          {will be inverse of FWD}
  :boolean;                            {TRUE if inverse exists}
  extern;

function vect_add (                    {add two vectors}
  in      v1: vect_3d_t;               {input vector 1}
  in      v2: vect_3d_t)               {input vector 2}
  :vect_3d_t;                          {resulting vector sum}
  extern;

procedure vect_adjm (                  {adjust the magnitude of a vector}
  in out  v: vect_3d_t;                {vector to adjust magnitude of}
  in      m: real);                    {desired magnitude of vector}
  extern;

function vect_cross (                  {take a cross product of two vectors}
  in      v1: vect_3d_t;               {first input vector of cross product}
  in      v2: vect_3d_t)               {second input vector of cross product}
  :vect_3d_t;                          {resulting cross product}
  extern;

function vect_dot (                    {find dot product of two vectors}
  in      v1: vect_3d_t;               {first input vector}
  in      v2: vect_3d_t)               {second input vector}
  :real;                               {resulting dot product value}
  extern;

function vect_mag (                    {find magnitude of a vector}
  in      v: vect_3d_t)                {input vector}
  :real;                               {output magnitude}
  extern;

function vect_mult (                   {multiply a vector by a scalar}
  in      v: vect_3d_t;                {input vector}
  in      m: real)                     {mult factor}
  :vect_3d_t;                          {result of V*M}
  extern;

function vect_sub (                    {return subtraction of two vectors}
  in      v1: vect_3d_t;               {input vector to be subtracted from}
  in      v2: vect_3d_t)               {input vector to subtract from V1}
  :vect_3d_t;                          {result of V1-V2}
  extern;

function vect_vector (                 {build a vector from 3 scalars}
  in      x: real;                     {X coor of vector}
  in      y: real;                     {Y coor of vector}
  in      Z: real)                     {Z coor of vector}
  :vect_3d_t;                          {resulting vector}
  extern;

function vect_xf3x3 (                  {transform coordinate thru 3x3 matrix}
  in      p: vect_3d_t;                {input coordinate}
  in      m: vect_mat3x3_t)            {transformation matrix}
  :vect_3d_t;                          {transformed coordinate}
  val_param; extern;

function vect_xf3x4 (                  {transform coordinate thru 3x4 matrix}
  in      p: vect_3d_t;                {input coordinate}
  in      m: vect_mat3x4_t)            {transformation matrix}
  :vect_3d_t;                          {transformed coordinate}
  val_param; extern;

function vect_m3x3_mult (              {multiply two 3x3 matricies}
  in      m1: vect_mat3x3_t;           {first input matrix}
  in      m2: vect_mat3x3_t)           {second input matrix}
  :vect_mat3x3_t;                      {result of M1 x M2}
  val_param; extern;

function vect_m3x4_mult (              {multiply two 3x4 matricies}
  in      m1: vect_mat3x4_t;           {first input matrix}
  in      m2: vect_mat3x4_t)           {second input matrix}
  :vect_mat3x4_t;                      {result of M1 x M2}
  val_param; extern;

function vect_m3x4_rotate_x (          {make 3x4 matrix for rotation around X axis}
  in      a: real)                     {rotation angle in radians}
  :vect_mat3x4_t;                      {returned rotation matrix}
  val_param; extern;

function vect_m3x4_rotate_y (          {make 3x4 matrix for rotation around Y axis}
  in      a: real)                     {rotation angle in radians}
  :vect_mat3x4_t;                      {returned rotation matrix}
  val_param; extern;

function vect_m3x4_rotate_z (          {make 3x4 matrix for rotation around Z axis}
  in      a: real)                     {rotation angle in radians}
  :vect_mat3x4_t;                      {returned rotation matrix}
  val_param; extern;

procedure vect_xf2d_mult (             {combine two 2D transforms}
  in      xfa, xfb: vect_xf2d_t;       {the 2D transforms to combine, in order}
  out     xfc: vect_xf2d_t);           {the resulting combined transform}
  val_param; extern;

procedure vect_xf2d_xfpnt (            {apply 2D transform to a point}
  in      x, y: real;                  {the input point}
  in      xf: vect_xf2d_t;             {the 2D transform to apply}
  out     p: vect_2d_t);               {resulting point}
  val_param; extern;
