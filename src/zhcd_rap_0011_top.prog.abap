*&---------------------------------------------------------------------*
*& Include          ZHCD_RAP_0011_TOP
*&---------------------------------------------------------------------*

CONTROLS tb_id TYPE TABSTRIP.

DATA: gv_bil_tarih   TYPE datum,
      gv_kaz_bil_tar TYPE datum,
      gv_bil_sayi    TYPE int4,
      gv_bil_tur     TYPE char1,
      gv_uname       TYPE char20.
gv_uname = sy-uname.

DATA: gv_id    TYPE vrm_id,
      gt_value TYPE vrm_values,
      gs_value TYPE vrm_value.

DATA: gt_bilet TYPE TABLE OF zhcd_s0010,
      gs_bilet TYPE zhcd_s0010,
      gt_odul  TYPE TABLE OF zhcd_s0011,
      gs_odul  TYPE zhcd_s0011.

DATA: gt_cek TYPE TABLE OF zhcd_t0005,
      gs_cek TYPE zhcd_t0005.

DATA: go_alv     TYPE REF TO cl_gui_alv_grid,
      go_alv2    TYPE REF TO cl_gui_alv_grid,
      go_cust    TYPE REF TO cl_gui_custom_container,
      go_cust2   TYPE REF TO cl_gui_custom_container,
      gs_layout  TYPE lvc_s_layo,
      gs_layout2 TYPE lvc_s_layo,
      gt_fcat    TYPE lvc_t_fcat,
      gt_fcat2   TYPE lvc_t_fcat,
      gs_fcat    TYPE lvc_s_fcat,
      gs_fcat2   TYPE lvc_s_fcat.

DATA: gv_cont   TYPE char50,
      gv_outtab TYPE char50,
      gv_strc   TYPE char50,
      gv_chc    TYPE xfeld.

gv_chc = ''.
