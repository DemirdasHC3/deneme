*&---------------------------------------------------------------------*
*& Include          ZHCD_RAP_0010_TOP
*&---------------------------------------------------------------------*

TYPES: BEGIN OF gtt_game,
         sayi TYPE int2,
       END OF gtt_game.

TYPES: BEGIN OF gtt_game2,
         cek_sayi TYPE int2,
         sayi     TYPE int2,
       END OF gtt_game2.

DATA: gt_game TYPE SORTED TABLE OF gtt_game
      WITH UNIQUE KEY sayi  WITH HEADER LINE.

DATA: gt_game2 TYPE SORTED TABLE OF gtt_game2
      WITH UNIQUE KEY cek_sayi sayi WITH HEADER LINE.

DATA gt_game3 TYPE TABLE OF zhcd_s0009.

DATA: gt_kazanan TYPE TABLE OF zhcd_s0008,
      gt_oynanan TYPE TABLE OF zhcd_s0008,
      gs_oynanan TYPE zhcd_s0008,
      gs_kazanan TYPE zhcd_s0008.

DATA: gv_id    TYPE vrm_id,
      gt_value TYPE vrm_values,
      gs_value TYPE vrm_value.

DATA: gv_mesaj   TYPE char200,
      gv_kazan   TYPE int4,
      gv_bakiye  TYPE int4,
      gv_tutar   TYPE int4,
      gv_adet    TYPE i VALUE '1',
      gv_adet2   TYPE i,
      gv_adet3   TYPE i,
      gv_chc     TYPE xfeld,
      gv_hata    TYPE xfeld,
      gv_hata2   TYPE xfeld,
      gv_chc2    TYPE xfeld,
      gv_chc3    TYPE xfeld,
      gv_cek_say TYPE int2.

DATA: gv_check  TYPE xfeld VALUE ''.

gv_cek_say = 1.
gv_bakiye = 500.
gv_chc = abap_true.
gv_chc2 = abap_true.
gv_chc3 = abap_true.

DATA: gt_popfcat TYPE TABLE OF slis_fieldcat_alv,
      gs_poplayo TYPE slis_layout_alv.
