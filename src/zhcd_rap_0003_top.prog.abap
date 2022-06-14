*&---------------------------------------------------------------------*
*& Include          ZHCD_RAP_0003_TOP
*&---------------------------------------------------------------------*
TABLES zhcd_t0001.

DATA: gt_data    TYPE TABLE OF zhcd_t0001,
      gt_ilkodu  TYPE TABLE OF zhcd_t0001,
      gt_malzeme TYPE TABLE OF zhcd_t0001.

"Alv için gerekli tanımlamalar.
DATA: gt_fcat   TYPE lvc_t_fcat,
      gs_fcat   TYPE lvc_s_fcat,
      go_grid   TYPE REF TO cl_gui_alv_grid,
      gs_layout TYPE lvc_s_layo.

"Dinamik yapı için tanımlar.
DATA: go_table TYPE REF TO data, "Tablo tanımında kullanılacak.
      gs_table TYPE REF TO data. "Structure tanımında kullanılacak.

FIELD-SYMBOLS: <dyn_table> TYPE STANDARD TABLE,
               <gfs_table>,
               <gfs1>.
