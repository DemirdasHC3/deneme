*&---------------------------------------------------------------------*
*& Report ZHCD_RAP_0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZHCD_RAP_0004.


TYPE-POOLS: slis.
*- Fieldcatalog
DATA: it_fieldcat TYPE lvc_t_fcat.
DATA: x_fieldcat TYPE lvc_s_fcat.
DATA: x_layout TYPE lvc_s_layo.
"{ FOR DISABLE
DATA: ls_edit TYPE lvc_s_styl,
      lt_edit TYPE lvc_t_styl.
"} FOR DISABLE
DATA: BEGIN OF it_vbap OCCURS 0,
vbeln LIKE vbap-vbeln,
posnr LIKE vbap-posnr,
style TYPE lvc_t_styl, "FOR DISABLE
END OF it_vbap.
DATA: ls_outtab LIKE LINE OF it_vbap.
SELECT  vbeln
        posnr
  UP TO 10 ROWS
  INTO CORRESPONDING FIELDS OF TABLE it_vbap
  FROM vbap.

DATA:l_pos TYPE i VALUE 1.
CLEAR: l_pos.
l_pos = l_pos + 1.
x_fieldcat-seltext = 'VBELN'.
x_fieldcat-fieldname = 'VBELN'.
x_fieldcat-tabname = 'ITAB'.
x_fieldcat-col_pos = l_pos.
x_fieldcat-edit = 'X'.
x_fieldcat-outputlen = '10'.
x_fieldcat-ref_field = 'VBELN'.
x_fieldcat-ref_table = 'VBAK'.
APPEND x_fieldcat TO it_fieldcat.
CLEAR x_fieldcat.
l_pos = l_pos + 1.
x_fieldcat-seltext = 'POSNR'.
x_fieldcat-fieldname = 'POSNR'.
x_fieldcat-tabname = 'ITAB'.
x_fieldcat-col_pos = l_pos.
x_fieldcat-edit = 'X'.
x_fieldcat-outputlen = '5'.
APPEND x_fieldcat TO it_fieldcat.
CLEAR x_fieldcat.
l_pos = l_pos + 1.
"{FOR DISABLE HERE 6ROW IS DISABLED
sy-tabix = 6.
ls_edit-fieldname = 'VBELN'.
ls_edit-style = cl_gui_alv_grid=>mc_style_disabled.
ls_edit-style2 = space.
ls_edit-style3 = space.
ls_edit-style4 = space.
ls_edit-maxlen = 10.
INSERT ls_edit INTO TABLE lt_edit.
ls_edit-fieldname = 'POSNR'.
ls_edit-style = cl_gui_alv_grid=>mc_style_disabled.
ls_edit-style2 = space.
ls_edit-style3 = space.
ls_edit-style4 = space.
ls_edit-maxlen = 6.
INSERT ls_edit INTO TABLE lt_edit.
INSERT LINES OF lt_edit INTO TABLE ls_outtab-style.
MODIFY it_vbap INDEX sy-tabix FROM ls_outtab TRANSPORTING
style .
x_layout-stylefname = 'STYLE'.
"} UP TO HERE
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
  EXPORTING
    i_callback_program = sy-repid
    is_layout_lvc      = x_layout
    it_fieldcat_lvc    = it_fieldcat
  TABLES
    t_outtab           = it_vbap[]
  EXCEPTIONS
    program_error      = 1
    OTHERS             = 2.
IF sy-subrc NE 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
