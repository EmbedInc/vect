{   Program TEST_MAT_EX <mat file name> <ex file name>
*
*   Test converting a 3x3 matrix to its expanded form.
*   The 3x3 matrix file is in the following format:
*
*     xb.x    xb.y    xb.z
*     yb.x    yb.y    yb.z
*     zb.x    zb.y    zb.z
*
*   The expanded matrix file will be in the following format:
*
*     skew_yb.x    skew_yb.y    skew_yb.z
*     skew_zb.x    skew_zb.y    skew_zb.z
*
*     rot_xb.x     rot_xb.y     rot_xb.z
*     rot_yb.x     rot_yb.y     rot_yb.z
*
*     scale_x
*     scale_y
*     scale_z
}
program test_mat_ex;
%include '/cognivision_links/dsee_libs/sys/sys.ins.pas';
%include '/cognivision_links/dsee_libs/util/util.ins.pas';
%include '/cognivision_links/dsee_libs/string/string.ins.pas';
%include '/cognivision_links/dsee_libs/file/file.ins.pas';
%include '/cognivision_links/dsee_libs/vect/vect.ins.pas';

const
  max_msg_parms = 1;                   {max parameters we can pass to a message}

var
  conn_in, conn_out: file_conn_t;      {input/output file connection handles}
  token:                               {for parsing command line and input file}
    %include '/cognivision_links/dsee_libs/string/string_treename.ins.pas';
  buf:                                 {one line input/output buffer}
    %include '/cognivision_links/dsee_libs/string/string132.ins.pas';
  p: string_index_t;                   {input line parse index}
  mat: vect_mat3x3_t;                  {3x3 matrix}
  ex: vect_exp3x3_t;                   {expanded form of matrix}
  err: boolean;                        {TRUE if convert failed}
  msg_parm:                            {parameter references for messages}
    array[1..max_msg_parms] of sys_parm_msg_t;
  stat: sys_err_t;

label
  leave;

{
****************************
*
*   Local subroutine READ_LINE
*
*   Read the next line from the input file.
}
procedure read_line;

var
  stat: sys_err_t;

label
  again;

begin
again:                                 {back here on blank line}
  file_read_text (conn_in,buf,stat);
  sys_error_abort (stat,'file','read_input_text',nil,0);
  if buf.len <= 0 then goto again;
  p := 1;                              {init new BUF parse index}
  end;
{
****************************
*
*   Local subroutine READ_VAL (VAL)
*
*   Return the value from the next token on the current input line.
}
procedure read_val (
  out     val: real);

var
  stat: sys_err_t;

begin
  string_token_fpm (buf,p,val,stat);
  sys_error_abort (stat,'','',nil,0);
  end;
{
****************************
*
*   Local subroutine WRITE_LINE
*
*   Write the current output buffer to the output file.
}
procedure write_line;

var
  stat: sys_err_t;

begin
  file_write_text (buf,conn_out,stat);
  sys_error_abort (stat,'file','write_output_text',nil,0);
  buf.len := 0;                        {reset buffer to empty}
  end;
{
****************************
*
*   Local subroutine WRITE_VAL (VAL)
*
*   Write the value VAL as the next token to the current output line.
}
procedure write_val (
  in      val: real);

var
  token: string_var32_t;

begin
  token.max := sizeof(token.str);      {init local var string}
  string_f_fp_ftn (                    {convert value to string}
    token,                             {output string}
    val,                               {input value}
    8,                                 {field width}
    3);                                {digits below decimal point}
  if buf.len > 0 then begin            {not first token in buffer ?}
    string_append1 (buf,' ');
    end;
  string_append (buf,token);           {write number to output buffer}
  end;
{
****************************
*
*   Start of main routine.
}
begin
  string_cmline_init;                  {init for reading command line}

  string_cmline_token (token,stat);    {get input file name}
  string_cmline_req_check (stat);
  file_open_read_text (token,'',conn_in,stat); {try to open input file for read}
  sys_msg_parm_vstr (msg_parm[1],token);
  sys_error_abort (stat,'file','open_input_read_text',msg_parm,1);

  string_cmline_token (token,stat);    {get output file name}
  string_cmline_req_check (stat);
  file_open_write_text (token,'',conn_out,stat); {try to open output file for write}
  sys_msg_parm_vstr (msg_parm[1],token);
  sys_error_abort (stat,'file','open_output_write_text',msg_parm,1);

  string_cmline_end_abort;             {no more tokens allowed on command line}
{
*   All done reading command line and both files opened successfully.
*   Now read the data from the input file into MAT.
}
  read_line;
  read_val (mat.xb.x);
  read_val (mat.xb.y);
  read_val (mat.xb.z);
  read_line;
  read_val (mat.yb.x);
  read_val (mat.yb.y);
  read_val (mat.yb.z);
  read_line;
  read_val (mat.zb.x);
  read_val (mat.zb.y);
  read_val (mat.zb.z);
  file_close (conn_in);                {close input file}
{
*   Convert the data.
}
  vect_3x3_exp_to (mat,ex,err);        {try to convert the data}
  if err then begin
    writeln ('Conversion not possible.');
    goto leave;
    end;
{
*   Write the converted data to the output file.
}
  buf.len := 0;                        {init output buffer}

  write_val (ex.skew_yb.x);            {skew component}
  write_val (ex.skew_yb.y);
  write_val (ex.skew_yb.z);
  write_line;
  write_val (ex.skew_zb.x);
  write_val (ex.skew_zb.y);
  write_val (ex.skew_zb.z);
  write_line;
  write_line;

  write_val (ex.rot_xb.x);             {rotation component}
  write_val (ex.rot_xb.y);
  write_val (ex.rot_xb.z);
  write_line;
  write_val (ex.rot_yb.x);
  write_val (ex.rot_yb.y);
  write_val (ex.rot_yb.z);
  write_line;
  write_line;

  write_val (ex.scale_x);              {scaling factors}
  write_line;
  write_val (ex.scale_y);
  write_line;
  write_val (ex.scale_z);
  write_line;

leave:                                 {common exit point}
  file_close (conn_out);
  end.
