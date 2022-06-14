*&---------------------------------------------------------------------*
*& Include          ZHCD_RAP_0011_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form DROP_DOWN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM drop_down .
  REFRESH gt_value.
  gv_id = 'GV_BIL_TUR'.
  gs_value-key = 'C'.
  gs_value-text = '- Çeyrek Bilet'.
  APPEND gs_value TO gt_value.

  gs_value-key = 'Y'.
  gs_value-text = '- Yarım Bilet'.
  APPEND gs_value TO gt_value.

  gs_value-key = 'T'.
  gs_value-text = '- Tam Bilet'.
  APPEND gs_value TO gt_value.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = gv_id
      values = gt_value.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form BILET_AL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM bilet_al .
  DATA lv_i TYPE int4.
  DATA lv_s TYPE int4.
  REFRESH gt_bilet.
  lv_i = 1.
  lv_s = gv_bil_sayi.

  WHILE  lv_i LE lv_s.
    CALL FUNCTION 'RANDOM_I4'
      EXPORTING
        rnd_min   = 1000000
        rnd_max   = 9999999
      IMPORTING
        rnd_value = gs_bilet-bilet_no.

    gs_bilet-bilet_turu = gv_bil_tur.
    gs_bilet-cekilis_tarihi = gv_bil_tarih.
    APPEND gs_bilet TO gt_bilet.

    lv_i = lv_i + 1.
  ENDWHILE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALL_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM call_alv .
  PERFORM set_fcat.
  PERFORM set_layout.

  IF go_alv IS INITIAL.

    CREATE OBJECT go_cust
      EXPORTING
        container_name = 'CONT_1'. "'CONT_1'. "gv_cont

    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_cust. "cl_gui_container=>screen0.

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        i_structure_name = 'ZHCD_S0010' "'ZHCD_S0010' "gv_structure
        is_layout        = gs_layout
      CHANGING
        it_outtab        = gt_bilet "gt_bilet "gv_outtab
        it_fieldcatalog  = gt_fcat.
  ELSE.
    CALL METHOD go_alv->refresh_table_display .
    CALL METHOD cl_gui_cfw=>flush .
  ENDIF.

ENDFORM.

FORM call_alv2 .
  PERFORM set_fcat2.
  PERFORM set_layout2.

  IF go_alv2 IS INITIAL.

    CREATE OBJECT go_cust2
      EXPORTING
        container_name = 'CONT_2'. "'CONT_1'. "gv_cont

    CREATE OBJECT go_alv2
      EXPORTING
        i_parent = go_cust2. "cl_gui_container=>screen0.

    CALL METHOD go_alv2->set_table_for_first_display
      EXPORTING
        i_structure_name = 'ZHCD_S0011' "'ZHCD_S0010' "gv_structure
        is_layout        = gs_layout2
      CHANGING
        it_outtab        = gt_odul "gt_bilet "gv_outtab
        it_fieldcatalog  = gt_fcat2.
  ELSE.
    CALL METHOD go_alv2->refresh_table_display .
    CALL METHOD cl_gui_cfw=>flush .
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat .
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZHCD_S0010' "'ZHCD_S0010'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT gt_fcat ASSIGNING FIELD-SYMBOL(<lfs_fcat>).
    IF <lfs_fcat>-fieldname = 'BILET_NO'.
      <lfs_fcat>-scrtext_s =
      <lfs_fcat>-scrtext_m =
      <lfs_fcat>-scrtext_l = 'Bilet Numarası'.
      <lfs_fcat>-datatype = 'CHAR50'.
      <lfs_fcat>-outputlen = 15.


    ELSEIF <lfs_fcat>-fieldname = 'BILET_TURU'.
      <lfs_fcat>-scrtext_s =
      <lfs_fcat>-scrtext_m =
      <lfs_fcat>-scrtext_l = 'Bilet Türü'.
      <lfs_fcat>-datatype = 'CHAR50'.
      <lfs_fcat>-outputlen = 10.

    ELSEIF <lfs_fcat>-fieldname = 'CEKILIS_TARIHI'.
      <lfs_fcat>-scrtext_s =
      <lfs_fcat>-scrtext_m =
      <lfs_fcat>-scrtext_l = 'Çekiliş Tarihi'.
*      <lfs_fcat>-datatype = 'CHAR50'.
      <lfs_fcat>-outputlen = 15.

    ENDIF.

  ENDLOOP.
ENDFORM.

FORM set_fcat2 .
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZHCD_S0011' "'ZHCD_S0010'
    CHANGING
      ct_fieldcat            = gt_fcat2
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT gt_fcat2 ASSIGNING FIELD-SYMBOL(<lfs_fcat2>).
    IF <lfs_fcat2>-fieldname = 'KAZANAN_NUMS'.
      <lfs_fcat2>-scrtext_s =
      <lfs_fcat2>-scrtext_m =
      <lfs_fcat2>-scrtext_l = 'Kazanan Numaralar'.
*      <lfs_fcat2>-datatype = 'CHAR50'.
      <lfs_fcat2>-outputlen = 255.
      <lfs_fcat2>-just = 'L'.


    ELSEIF <lfs_fcat2>-fieldname = 'ODUL_TURU'.
      <lfs_fcat2>-scrtext_s =
      <lfs_fcat2>-scrtext_m =
      <lfs_fcat2>-scrtext_l = 'Ödül Türü'.
      <lfs_fcat2>-key = abap_true.
*      <lfs_fcat>-datatype = 'CHAR50'.
      <lfs_fcat2>-outputlen = 20.


    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layout-zebra = abap_true.
*  gs_layout-cwidth_opt = abap_true.
  gs_layout-sel_mode = 'A'.
ENDFORM.

FORM set_layout2 .
  gs_layout2-zebra = abap_true.
*  gs_layout2-cwidth_opt = abap_true.
*  gs_layout2-sel_mode = 'A'.
  gs_layout2-no_toolbar = abap_true.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form BILET_SAL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM bilet_sal .
  DATA: lt_selected_rows TYPE lvc_t_row,
        ls_selected_rows TYPE lvc_s_row,
        lv_lines         TYPE i,
        lv_flag          TYPE xfeld,
        ls_sal           TYPE zhcd_t0004.

  CALL METHOD go_alv->get_selected_rows
    IMPORTING
      et_index_rows = lt_selected_rows.

  lv_lines = lines( lt_selected_rows ).

  IF lv_lines EQ 0.
    MESSAGE 'Satır Seçiniz !' TYPE 'I' DISPLAY LIKE 'E'.
  ELSE.
    LOOP AT lt_selected_rows INTO ls_selected_rows.
      CLEAR: ls_sal.
      READ TABLE gt_bilet ASSIGNING FIELD-SYMBOL(<lfs_bilet>) INDEX ls_selected_rows-index.

      ls_sal-user_id = sy-uname.
      MOVE-CORRESPONDING <lfs_bilet> TO ls_sal.

      INSERT zhcd_t0004 FROM ls_sal.
      IF  sy-subrc EQ 0.
        lv_flag = 'X'.
      ENDIF.
      CLEAR lv_flag.
    ENDLOOP.
    MESSAGE |{ lv_lines } Tane bilet alındı.| TYPE 'I' DISPLAY LIKE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CEKILIS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM cekilis .

  DATA lv_bilet TYPE int4.
  DATA lv_say TYPE int4.
  DATA lv_say2 TYPE string.
  DATA lv_text TYPE string.
  lv_bilet = 1.
  lv_say = 0.

  REFRESH : gt_cek , gt_odul.
  CLEAR : gs_cek , gs_odul.

  DO 7 TIMES.
    gs_cek-cekilis_tarihi = gv_kaz_bil_tar.

    IF lv_bilet EQ 7.
      CALL FUNCTION 'RANDOM_I4'    " random function.
        EXPORTING
          rnd_min   = 1000000
          rnd_max   = 9999999
        IMPORTING
          rnd_value = gs_cek-bilet_no.
      APPEND gs_cek TO gt_cek.

      lv_say2 = gs_cek-bilet_no.
      lv_text = lv_say2.
      gs_odul-kazanan_nums = lv_text.

*      gs_odul2-kazanan_nums = gs_cek-bilet_no.
*      gs_odul2-odul_turu = 'Büyük Ödül'.
*      MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*      APPEND gs_odul2_s TO gt_odul2.
      CLEAR: lv_say2.
      gs_odul-odul_turu = 'Büyük Ödül'.
      APPEND gs_odul TO gt_odul.
      CLEAR: lv_say, gs_odul, lv_text.


    ELSEIF lv_bilet EQ 6.
      WHILE lv_say LT 5 .
        CALL FUNCTION 'RANDOM_I4'    " random function.
          EXPORTING
            rnd_min   = 100000
            rnd_max   = 999999
          IMPORTING
            rnd_value = gs_cek-bilet_no.
*      INSERT gt_cek FROM gs_cek.
        READ TABLE gt_cek INTO DATA(ls_cek) WITH KEY bilet_no = gs_cek-bilet_no.
        IF sy-subrc EQ 0.
          CONTINUE.
        ELSE.
          APPEND gs_cek TO gt_cek.
          lv_say2 = gs_cek-bilet_no.
          CONCATENATE lv_text '-' lv_say2 INTO lv_text .
          gs_odul-kazanan_nums = lv_text.
*          gs_odul2-kazanan_nums = gs_cek-bilet_no.
          lv_say = lv_say + 1.
*          gs_odul2-odul_turu = 'Son 6 bilet_noına Göre Bilet Numarası'.
*          MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*          APPEND gs_odul2_s TO gt_odul2.
          CLEAR: lv_say2.
        ENDIF.

      ENDWHILE.
      gs_odul-odul_turu = 'Son 6 Numaraya Göre'.
      APPEND gs_odul TO gt_odul.
      CLEAR: lv_say,ls_cek, gs_odul, lv_text.

    ELSEIF lv_bilet EQ 5.
      WHILE lv_say LT 10 .
        CALL FUNCTION 'RANDOM_I4'    " random function.
          EXPORTING
            rnd_min   = 10000
            rnd_max   = 99999
          IMPORTING
            rnd_value = gs_cek-bilet_no.
*      INSERT gt_cek FROM gs_cek.
        READ TABLE gt_cek INTO ls_cek WITH KEY bilet_no = gs_cek-bilet_no.
        IF sy-subrc EQ 0.
          CONTINUE.
        ELSE.
          APPEND gs_cek TO gt_cek.
          lv_say2 = gs_cek-bilet_no.
          CONCATENATE lv_text '-' lv_say2 INTO lv_text .
          gs_odul-kazanan_nums = lv_text.
*          gs_odul2-kazanan_nums = gs_cek-bilet_no.
          lv_say = lv_say + 1.
*          gs_odul2-odul_turu = 'Son 6 bilet_noına Göre Bilet Numarası'.
*          MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*          APPEND gs_odul2_s TO gt_odul2.
          CLEAR: lv_say2.
        ENDIF.

      ENDWHILE.
      gs_odul-odul_turu = 'Son 5 Numaraya Göre'.
      APPEND gs_odul TO gt_odul.
      CLEAR: lv_say,ls_cek, gs_odul, lv_text.


    ELSEIF lv_bilet EQ 4.
      WHILE lv_say LT 15 .
        CALL FUNCTION 'RANDOM_I4'    " random function.
          EXPORTING
            rnd_min   = 1000
            rnd_max   = 9999
          IMPORTING
            rnd_value = gs_cek-bilet_no.
*      INSERT gt_cek FROM gs_cek.
        READ TABLE gt_cek INTO ls_cek WITH KEY bilet_no = gs_cek-bilet_no.
        IF sy-subrc EQ 0.
          CONTINUE.
        ELSE.
          APPEND gs_cek TO gt_cek.
          lv_say2 = gs_cek-bilet_no.
          CONCATENATE lv_text '-' lv_say2 INTO lv_text .
          gs_odul-kazanan_nums = lv_text.
*          gs_odul2-kazanan_nums = gs_cek-bilet_no.
          lv_say = lv_say + 1.
*          gs_odul2-odul_turu = 'Son 6 bilet_noına Göre Bilet Numarası'.
*          MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*          APPEND gs_odul2_s TO gt_odul2.
          CLEAR: lv_say2.
        ENDIF.

      ENDWHILE.
      gs_odul-odul_turu = 'Son 4 Numaraya Göre'.
      APPEND gs_odul TO gt_odul.
      CLEAR: lv_say,ls_cek, gs_odul, lv_text.

          ELSEIF lv_bilet EQ 3.
      WHILE lv_say LT 20 .
        CALL FUNCTION 'RANDOM_I4'    " random function.
          EXPORTING
            rnd_min   = 100
            rnd_max   = 999
          IMPORTING
            rnd_value = gs_cek-bilet_no.
*      INSERT gt_cek FROM gs_cek.
        READ TABLE gt_cek INTO ls_cek WITH KEY bilet_no = gs_cek-bilet_no.
        IF sy-subrc EQ 0.
          CONTINUE.
        ELSE.
          APPEND gs_cek TO gt_cek.
          lv_say2 = gs_cek-bilet_no.
          CONCATENATE lv_text '-' lv_say2 INTO lv_text .
          gs_odul-kazanan_nums = lv_text.
*          gs_odul2-kazanan_nums = gs_cek-bilet_no.
          lv_say = lv_say + 1.
*          gs_odul2-odul_turu = 'Son 6 bilet_noına Göre Bilet Numarası'.
*          MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*          APPEND gs_odul2_s TO gt_odul2.
          CLEAR: lv_say2.
        ENDIF.

      ENDWHILE.
      gs_odul-odul_turu = 'Son 3 Numaraya Göre'.
      APPEND gs_odul TO gt_odul.
      CLEAR: lv_say,ls_cek, gs_odul, lv_text.

          ELSEIF lv_bilet EQ 2.
      WHILE lv_say LT 25 .
        CALL FUNCTION 'RANDOM_I4'    " random function.
          EXPORTING
            rnd_min   = 10
            rnd_max   = 99
          IMPORTING
            rnd_value = gs_cek-bilet_no.
*      INSERT gt_cek FROM gs_cek.
        READ TABLE gt_cek INTO ls_cek WITH KEY bilet_no = gs_cek-bilet_no.
        IF sy-subrc EQ 0.
          CONTINUE.
        ELSE.
          APPEND gs_cek TO gt_cek.
          lv_say2 = gs_cek-bilet_no.
          CONCATENATE lv_text '-' lv_say2 INTO lv_text .
          gs_odul-kazanan_nums = lv_text.
*          gs_odul2-kazanan_nums = gs_cek-bilet_no.
          lv_say = lv_say + 1.
*          gs_odul2-odul_turu = 'Son 6 bilet_noına Göre Bilet Numarası'.
*          MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*          APPEND gs_odul2_s TO gt_odul2.
          CLEAR: lv_say2.
        ENDIF.

      ENDWHILE.
      gs_odul-odul_turu = 'Son 2 Numaraya Göre'.
      APPEND gs_odul TO gt_odul.
      CLEAR: lv_say,ls_cek, gs_odul, lv_text.

          ELSEIF lv_bilet EQ 1.
      WHILE lv_say LT 2 .
        CALL FUNCTION 'RANDOM_I4'    " random function.
          EXPORTING
            rnd_min   = 1
            rnd_max   = 9
          IMPORTING
            rnd_value = gs_cek-bilet_no.
*      INSERT gt_cek FROM gs_cek.
        READ TABLE gt_cek INTO ls_cek WITH KEY bilet_no = gs_cek-bilet_no.
        IF sy-subrc EQ 0.
          CONTINUE.
        ELSE.
          APPEND gs_cek TO gt_cek.
          lv_say2 = gs_cek-bilet_no.
          CONCATENATE lv_text '-' lv_say2 INTO lv_text .
          gs_odul-kazanan_nums = lv_text.
*          gs_odul2-kazanan_nums = gs_cek-bilet_no.
          lv_say = lv_say + 1.
*          gs_odul2-odul_turu = 'Son 6 bilet_noına Göre Bilet Numarası'.
*          MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*          APPEND gs_odul2_s TO gt_odul2.
          CLEAR: lv_say2.
        ENDIF.

      ENDWHILE.
      gs_odul-odul_turu = 'Amorti'.
      APPEND gs_odul TO gt_odul.
      CLEAR: lv_say,ls_cek, gs_odul, lv_text.

*    ELSEIF lv_bilet EQ 5.
*      WHILE lv_say LT 10 .
*        CALL FUNCTION 'RANDOM_I4'    " random function.
*          EXPORTING
*            rnd_min   = 10000
*            rnd_max   = 99999
*          IMPORTING
*            rnd_value = gs_cek-bilet_no.
**      INSERT gt_cek FROM gs_cek.
*        READ TABLE gt_cek INTO ls_cek WITH KEY bilet_no = gs_cek-bilet_no.
*        IF sy-subrc EQ 0.
*          CONTINUE.
*        ELSE.
*          APPEND gs_cek TO gt_cek.
*          lv_say2 = gs_cek-bilet_no.
*          CONCATENATE lv_text '-' lv_say2 INTO lv_text SEPARATED BY space.
*          gs_odul-kazanan_nums = lv_text.
*          gs_odul2-kazanan_nums = gs_cek-bilet_no.
*          lv_say = lv_say + 1.
*          gs_odul2-odul_turu = 'Son 5 bilet_noına Göre Bilet Numarası'.
*          MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*          APPEND gs_odul2_s TO gt_odul2.
*          CLEAR: lv_say2.
*        ENDIF.
*
*      ENDWHILE.
*      gs_odul-odul_turu = 'Son 5 bilet_noına Göre Bilet Numarası'.
*      APPEND gs_odul TO gt_odul.
*      CLEAR: lv_say,ls_cek, gs_odul, lv_text.
*
*
*    ELSEIF lv_bilet EQ 4.
*      WHILE lv_say LT 15 .
*        CALL FUNCTION 'RANDOM_I4'    " random function.
*          EXPORTING
*            rnd_min   = 1000
*            rnd_max   = 9999
*          IMPORTING
*            rnd_value = gs_cek-bilet_no.
*        READ TABLE gt_cek INTO ls_cek WITH KEY bilet_no = gs_cek-bilet_no.
*        IF sy-subrc EQ 0.
*          CONTINUE.
*        ELSE.
*          APPEND gs_cek TO gt_cek.
*          lv_say2 = gs_cek-bilet_no.
*          CONCATENATE lv_text '-' lv_say2 INTO lv_text SEPARATED BY space.
*          gs_odul-kazanan_nums = lv_text.
*          gs_odul2-kazanan_nums = gs_cek-bilet_no.
*          lv_say = lv_say + 1.
*          gs_odul2-odul_turu = 'Son 4 bilet_noına Göre Bilet Numarası'.
*          MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*          APPEND gs_odul2_s TO gt_odul2.
*          CLEAR: lv_say2.
*        ENDIF.
*
*      ENDWHILE.
*      gs_odul-odul_turu = 'Son 4 bilet_noına Göre Bilet Numarası'.
*      APPEND gs_odul TO gt_odul.
*      CLEAR: lv_say,ls_cek, gs_odul, lv_text.
*
*
*    ELSEIF lv_bilet EQ 3.
*      WHILE lv_say LT 20 .
*        CALL FUNCTION 'RANDOM_I4'    " random function.
*          EXPORTING
*            rnd_min   = 100
*            rnd_max   = 999
*          IMPORTING
*            rnd_value = gs_cek-bilet_no.
**      INSERT gt_cek FROM gs_cek.
*        READ TABLE gt_cek INTO ls_cek WITH KEY bilet_no = gs_cek-bilet_no.
*        IF sy-subrc EQ 0.
*          CONTINUE.
*        ELSE.
*          APPEND gs_cek TO gt_cek.
*          lv_say2 = gs_cek-bilet_no.
*          CONCATENATE lv_text '-' lv_say2 INTO lv_text .
*          gs_odul-kazanan_nums = lv_text.
*          gs_odul2-kazanan_nums = gs_cek-bilet_no.
*          lv_say = lv_say + 1.
*          gs_odul2-odul_turu = 'Son 3 bilet_noına Göre Bilet Numarası'.
*          MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*          APPEND gs_odul2_s TO gt_odul2.
*          CLEAR: lv_say2.
*        ENDIF.
*
*      ENDWHILE.
*      gs_odul-odul_turu = 'Son 3 bilet_noına Göre Bilet Numarası'.
*      APPEND gs_odul TO gt_odul.
*      CLEAR: lv_say,ls_cek, gs_odul, lv_text.
*
*
*    ELSEIF lv_bilet EQ 2.
*      WHILE lv_say LT 25 .
*        CLEAR: lv_say2.
*        CALL FUNCTION 'RANDOM_I4'    " random function.
*          EXPORTING
*            rnd_min   = 10
*            rnd_max   = 99
*          IMPORTING
*            rnd_value = gs_cek-bilet_no.
*        READ TABLE gt_cek INTO ls_cek WITH KEY bilet_no = gs_cek-bilet_no.
*        IF sy-subrc EQ 0.
*          CONTINUE.
*          lv_say = lv_say - 1.
*        ELSE.
*          APPEND gs_cek TO gt_cek.
*          lv_say2 = gs_cek-bilet_no.
*          CONCATENATE lv_text '-' lv_say2 INTO lv_text.
*          gs_odul-kazanan_nums = lv_text.
*          gs_odul2-kazanan_nums = gs_cek-bilet_no.
*          lv_say = lv_say + 1.
*
*          gs_odul2-odul_turu = 'Son 2 bilet_noına Göre Bilet Numarası'.
*          MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*          APPEND gs_odul2_s TO gt_odul2.
*        ENDIF.
*
*      ENDWHILE.
*      gs_odul-odul_turu = 'Son 2 bilet_noına Göre Bilet Numarası'.
*      APPEND gs_odul TO gt_odul.
*      CLEAR: lv_say,ls_cek, gs_odul, lv_text.
*
*
*    ELSEIF lv_bilet EQ 1.
*      WHILE lv_say LT 2 .
*        CALL FUNCTION 'RANDOM_I4'    " random function.
*          EXPORTING
*            rnd_min   = 1
*            rnd_max   = 9
*          IMPORTING
*            rnd_value = gs_cek-bilet_no.
*        READ TABLE gt_cek INTO ls_cek WITH KEY bilet_no = gs_cek-bilet_no.
*        IF sy-subrc EQ 0.
*          CONTINUE.
*        ELSE.
*          APPEND gs_cek TO gt_cek.
*          lv_say2 = gs_cek-bilet_no.
*          CONCATENATE lv_text '-' lv_say2 INTO lv_text.
*          gs_odul-kazanan_nums = lv_text.
*          gs_odul2-kazanan_nums = gs_cek-bilet_no.
*          lv_say = lv_say + 1.
*
*          gs_odul2-odul_turu = 'Amorti'.
*          MOVE-CORRESPONDING gs_odul2 TO gs_odul2_s.
*          APPEND gs_odul2_s TO gt_odul2.
*          CLEAR: lv_say2.
*        ENDIF.
*
*      ENDWHILE.
*      gs_odul-odul_turu = 'Amorti'.
*      APPEND gs_odul TO gt_odul.
*      CLEAR: lv_say,ls_cek, gs_odul,lv_text.
    ENDIF.
    lv_bilet = lv_bilet + 1.
*    CLEAR: gs_odul2.

  ENDDO.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SCREEN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_screen .
  LOOP AT SCREEN.
    IF gv_chc EQ 'X'.
*      IF screen-group1 EQ 'C1'.
      IF screen-name EQ 'CEKYAP1'.
        screen-invisible = 1.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
    ENDLOOP.

ENDFORM.
