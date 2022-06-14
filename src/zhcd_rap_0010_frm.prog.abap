*&---------------------------------------------------------------------*
*& Include          ZHCD_RAP_0010_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form KAZANAN_SAYI
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM kazanan_sayi .

  DATA lv_cnt  TYPE int2.
  DATA lv_sayi TYPE int2.

  CLEAR: gs_kazanan.
  REFRESH: gt_game.

  DO 6 TIMES.
    CALL FUNCTION 'RANDOM_I2'
      EXPORTING
        rnd_min   = 1
        rnd_max   = 49
      IMPORTING
        rnd_value = lv_sayi.

    gt_game-sayi = lv_sayi.
    INSERT TABLE gt_game.
    lv_cnt    = lv_cnt + 1.
    CASE lv_cnt.
      WHEN '1'.
        gs_kazanan-1_num = lv_sayi.
      WHEN '2'.
        gs_kazanan-2_num = lv_sayi.
      WHEN '3'.
        gs_kazanan-3_num = lv_sayi.
      WHEN '4'.
        gs_kazanan-4_num = lv_sayi.
      WHEN '5'.
        gs_kazanan-5_num = lv_sayi.
      WHEN '6'.
        gs_kazanan-6_num = lv_sayi.
*    	WHEN OTHERS.
    ENDCASE.
    CLEAR: lv_sayi.
  ENDDO.

  gs_kazanan-cek_say = gv_cek_say.
  APPEND gs_kazanan TO gt_kazanan.

  gv_mesaj = |{ gv_cek_say }. Çekiliş |.
  gv_cek_say = gv_cek_say + 1.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form OYNANAN_SAYI
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM oynanan_sayi .

  DATA lv_ard TYPE int4.
  DATA lv_ard2 TYPE int4.
  DATA lv_sayi_alti TYPE int4.
  DATA lv_sayi_ustu TYPE int4.

  DATA lv_sayac TYPE int4.
  lv_sayac = 1.

  CLEAR: gv_hata, gv_hata2.
*  REFRESH: gt_game2,gt_oynanan.
*  DO 6 TIMES.
*    CASE lv_sayac.
*      WHEN 1.
*        gt_game2-sayi = gs_oynanan-1_num.
*      WHEN 2.
*        gt_game2-sayi = gs_oynanan-2_num.
*      WHEN 3.
*        gt_game2-sayi = gs_oynanan-3_num.
*      WHEN 4.
*        gt_game2-sayi = gs_oynanan-4_num.
*      WHEN 5.
*        gt_game2-sayi = gs_oynanan-5_num.
*      WHEN 6.
*        gt_game2-sayi = gs_oynanan-6_num.
*      WHEN OTHERS.
*    ENDCASE.
*    lv_sayac = lv_sayac + 1.
*    INSERT TABLE gt_game2.
*  ENDDO.

*  gs_oynanan-cek_say = gv_cek_say.
*  APPEND gs_oynanan TO gt_oynanan.


  IF gv_adet2 GE 0.
    gt_game2-cek_sayi = gv_adet2.
    DO 6 TIMES.
      CASE lv_sayac.
        WHEN 1.
          gt_game2-sayi = gs_oynanan-1_num.
        WHEN 2.
          gt_game2-sayi = gs_oynanan-2_num.
        WHEN 3.
          gt_game2-sayi = gs_oynanan-3_num.
        WHEN 4.
          gt_game2-sayi = gs_oynanan-4_num.
        WHEN 5.
          gt_game2-sayi = gs_oynanan-5_num.
        WHEN 6.
          gt_game2-sayi = gs_oynanan-6_num.
        WHEN OTHERS.
      ENDCASE.
      lv_sayac = lv_sayac + 1.
      IF gt_game2-sayi LE 1 AND gt_game2-sayi GE 49 AND gt_game2-cek_sayi EQ gv_adet2.
      ELSE.
        lv_ard2 = lv_ard2 + 1.
      ENDIF.
      INSERT TABLE gt_game2.
    ENDDO.
  ENDIF.

  CLEAR:lv_ard,lv_sayi_alti,lv_sayi_ustu.
  lv_ard = 0.
  LOOP AT gt_game2 INTO DATA(ls_gm2).
    lv_sayi_ustu = ls_gm2-sayi + 1.
    IF ls_gm2-sayi NE 0.
      lv_sayi_alti = ls_gm2-sayi - 1.
    ENDIF.
    READ TABLE gt_game2 WITH KEY sayi = lv_sayi_ustu
                                 cek_sayi = gv_adet2.
    IF sy-subrc EQ 0.
      READ TABLE gt_game2 WITH KEY sayi = lv_sayi_alti
                                  cek_sayi = gv_adet2.
      IF sy-subrc EQ 0.
        lv_ard = lv_ard + 1.
      ENDIF.
    ENDIF.
  ENDLOOP.
  IF  lv_ard GE 1.
    gv_hata = 'X'.
  ENDIF.
  IF lv_ard GE 2.
    gv_hata2 = 'X'.
  ENDIF.

  CLEAR gv_check.
  IF gv_hata EQ 'X'.
    MESSAGE 'Ardışık Sayıları kontrol Edin !' TYPE 'I' DISPLAY LIKE 'E'.
    REFRESH gt_game2.
    gv_check = 'X'.
  ELSEIF gv_hata2 EQ 'X'.
    MESSAGE 'Sayılar istenilen aralıkta değil !' TYPE 'I' DISPLAY LIKE 'E'.
    gv_check = 'X'.
  ELSE.
    gv_check = ''.

    gs_oynanan-cek_say = gv_adet2.
    APPEND gs_oynanan TO gt_oynanan.
    CLEAR: gs_oynanan.
  ENDIF.

*  PERFORM sayi_kont.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form KONTROL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM kontrol .
  DATA lv_kont TYPE int4.
  DATA lv_adet TYPE int2.
  lv_kont = 0.
  lv_adet = gv_adet3.

  DO gv_adet3 TIMES.
    LOOP AT gt_game INTO DATA(ls_game).
      READ TABLE gt_game2 INTO DATA(ls_game2) WITH KEY sayi = ls_game-sayi
                                                       cek_sayi = lv_adet.
      IF sy-subrc EQ 0.
        lv_kont = lv_kont + 1.
      ENDIF.
    ENDLOOP.
    lv_adet = lv_adet - 1.
  ENDDO.




  CLEAR: gv_kazan.
  SELECT SINGLE
    kazan_tut
    FROM zhcd_t0002
    INTO @gv_kazan
    WHERE bilinen_say EQ @lv_kont.

  IF lv_kont LE 3.
    MESSAGE 'Zort !' TYPE 'I'.
  ELSE.
    MESSAGE | Kazanılan Tutar : { gv_kazan } | TYPE 'I'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DROP_DOWN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM drop_down .
  REFRESH : gt_value.
  gv_id = 'GV_ADET'.
  gs_value-key = '1'.
  gs_value-text = 'Tutar: 50 TL'.
  APPEND gs_value TO gt_value.

  gs_value-key = '2'.
  gs_value-text = 'Tutar: 100 TL'.
  APPEND gs_value TO gt_value.

  gs_value-key = '3'.
  gs_value-text = 'Tutar: 150 TL'.
  APPEND gs_value TO gt_value.

  gs_value-key = '4'.
  gs_value-text = 'Tutar: 200 TL'.
  APPEND gs_value TO gt_value.

  gs_value-key = '5'.
  gs_value-text = 'Tutar: 250 TL'.
  APPEND gs_value TO gt_value.

  gs_value-key = '6'.
  gs_value-text = 'Tutar: 300 TL'.
  APPEND gs_value TO gt_value.

  gs_value-key = '7'.
  gs_value-text = 'Tutar: 350 TL'.
  APPEND gs_value TO gt_value.

  gs_value-key = '8'.
  gs_value-text = 'Tutar: 400 TL'.
  APPEND gs_value TO gt_value.

  gs_value-key = '9'.
  gs_value-text = 'Tutar: 450 TL'.
  APPEND gs_value TO gt_value.

  gs_value-key = '10'.
  gs_value-text = 'Tutar: 500 TL'.
  APPEND gs_value TO gt_value.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = gv_id
      values = gt_value.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form BILET_ADET
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM bilet_adet .

  CASE gv_adet.
    WHEN 1.
      IF gv_bakiye LT 50.
        MESSAGE 'Çulsuz ! Bakiye Yükle' TYPE 'I'.
      ELSE.
        gv_bakiye = gv_bakiye - 50.
        gv_adet2 = 1.
*        PERFORM oynanan_sayi.
      ENDIF.
    WHEN 2.
      IF gv_bakiye LT 100.
        MESSAGE 'Çulsuz ! 100 Yükle' TYPE 'I'.
      ELSE.
        gv_bakiye = gv_bakiye - 100.
        gv_adet2 = 2.
*        PERFORM oynanan_sayi.
*            PERFORM kazanan_sayi.
*            PERFORM kontrol.
      ENDIF.
    WHEN 3.
      IF gv_bakiye LT 150.
        MESSAGE 'Çulsuz ! 150 Yükle' TYPE 'I'.
      ELSE.
        gv_bakiye = gv_bakiye - 150.
        gv_adet2 = 3.
*        PERFORM oynanan_sayi.
*            PERFORM kazanan_sayi.
*            PERFORM kontrol.
      ENDIF.
    WHEN 4.
      IF gv_bakiye LT 200.
        MESSAGE 'Çulsuz ! 200 Yükle' TYPE 'I'.
      ELSE.
        gv_bakiye = gv_bakiye - 200.
        gv_adet2 = 4.
*        PERFORM oynanan_sayi.
*        PERFORM kazanan_sayi.
*        PERFORM kontrol.
      ENDIF.
    WHEN 5.
      IF gv_bakiye LT 250.
        MESSAGE 'Çulsuz ! 250 Yükle' TYPE 'I'.
      ELSE.
        gv_bakiye = gv_bakiye - 250.
        gv_adet2 = 5.
*        PERFORM oynanan_sayi.
*        PERFORM kazanan_sayi.
*        PERFORM kontrol.
      ENDIF.
    WHEN 6.
      IF gv_bakiye LT 300.
        MESSAGE 'Çulsuz ! 300 Yükle' TYPE 'I'.
      ELSE.
        gv_bakiye = gv_bakiye - 300.
        gv_adet2 = 6.
*        PERFORM oynanan_sayi.
*        PERFORM kazanan_sayi.
*        PERFORM kontrol.
      ENDIF.
    WHEN 7.
      IF gv_bakiye LT 350.
        MESSAGE 'Çulsuz ! 350 Yükle' TYPE 'I'.
      ELSE.
        gv_bakiye = gv_bakiye - 350.
        gv_adet2 = 7.
*        PERFORM oynanan_sayi.
*        PERFORM kazanan_sayi.
*        PERFORM kontrol.
      ENDIF.
    WHEN 8.
      IF gv_bakiye LT 400.
        MESSAGE 'Çulsuz ! 400 yok' TYPE 'I'.
      ELSE.
        gv_bakiye = gv_bakiye - 400.
        gv_adet2 = 8.
*        PERFORM oynanan_sayi.
*        PERFORM kazanan_sayi.
*        PERFORM kontrol.
      ENDIF.
    WHEN 9.
      IF gv_bakiye LT 450.
        MESSAGE 'Çulsuz ! 450 Yükle' TYPE 'I'.
      ELSE.
        gv_bakiye = gv_bakiye - 450.
        gv_adet2 = 9.
*        PERFORM oynanan_sayi.
*        PERFORM kazanan_sayi.
*        PERFORM kontrol.
      ENDIF.
    WHEN 10.
      IF gv_bakiye LT 500.
        MESSAGE 'Çulsuz ! 500 Yükle' TYPE 'I'.
      ELSE.
        gv_bakiye = gv_bakiye - 500.
        gv_adet2 = 10.
*        PERFORM oynanan_sayi.
*        PERFORM kazanan_sayi.
*        PERFORM kontrol.
*          WHEN OTHERS.
      ENDIF.
  ENDCASE.
  gv_adet3 = gv_adet2.
*  REFRESH gt_game2.
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
    IF gv_chc EQ abap_false.
      IF screen-group1 EQ 'C1'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.

    IF gv_chc3 EQ abap_true.
      IF screen-group1 EQ 'C3'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAYI_KONT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM sayi_kont .
  DATA lv_sonuc TYPE xfeld.

*  PERFORM oynanan_sayi.

  CALL FUNCTION 'ZHCD_F_ASAL_0001'
    EXPORTING
*     iv_sayi  =
      it_sayi  = gt_game2
    IMPORTING
      ev_sonuc = lv_sonuc.

  IF lv_sonuc EQ abap_true.
    IF gv_hata NE 'X'.

    ELSE.
      MESSAGE 'Sayıları Kontrol Ediniz!'TYPE 'I' DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  ENDIF.


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

*  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*    EXPORTING
*      i_program_name   = sy-repid
**     i_internal_tabname = 'GT_TABLE'
*      i_inclname       = sy-repid
*      i_structure_name = 'ZHCD_S0008'
*    CHANGING
*      ct_fieldcat      = gt_popfcat.

  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title                 = 'Biletlerim'
      i_zebra                 = 'X'
      i_tabname               = 1
      i_structure_name        = 'ZHCD_S0008'
*      it_fieldcat             = gt_popfcat
    TABLES
      t_outtab                = gt_oynanan.

ENDFORM.
