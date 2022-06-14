FUNCTION zhcd_f_asal_0001.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_SAYI) TYPE  INT4
*"     REFERENCE(IT_SAYI) TYPE  ZHCD_S0009_TT
*"  EXPORTING
*"     REFERENCE(EV_SONUC) TYPE  XFELD
*"----------------------------------------------------------------------

  DATA: lv_deger  TYPE int4,
        lv_deger2 TYPE int4,
        lv_bolen  TYPE int4.
*        lv_index TYPE int4.
  DATA(lv_index) = 1.

  DATA gv_tek TYPE xfeld.
  DATA gv_asal TYPE xfeld.
  DATA gv_nasal TYPE xfeld.
  DATA gv_cift TYPE xfeld.


*  DO iv_sayi TIMES.
*    lv_deger = iv_sayi MOD lv_index."sy-index.
*    IF lv_deger EQ 0.
*      lv_bolen = lv_bolen + 1.
*    ENDIF.
*    lv_index = lv_index + 1.
*  ENDDO.


*  IF lv_bolen NE 2.
*    MESSAGE i003(zhcd).
*  ELSE.
*    MESSAGE i002(zhcd).
*  ENDIF.
*
*  lv_deger2 =  iv_sayi MOD 2 .
*  IF lv_deger2 EQ 0.
*    MESSAGE i004(zhcd).
*  ELSE.
*    MESSAGE i005(zhcd).
*  ENDIF.


  LOOP AT it_sayi INTO DATA(ls_sayi).
    DO ls_sayi-sayi TIMES.
      lv_deger = ls_sayi-sayi MOD lv_index."sy-index.
      IF lv_deger EQ 0.
        lv_bolen = lv_bolen + 1.
      ENDIF.
      lv_index = lv_index + 1.
    ENDDO.
    IF lv_bolen NE 2.
      gv_nasal = abap_true.
    ELSE.
      gv_asal = abap_true.
    ENDIF.

    lv_deger2 =  iv_sayi MOD 2.
    IF lv_deger2 EQ 0.
      gv_cift = abap_true.
    ELSE.
      gv_tek = abap_true.
    ENDIF.
  ENDLOOP.

  IF      gv_nasal EQ abap_true
      AND gv_asal  EQ abap_true
      AND gv_cift  EQ abap_true
      AND gv_tek   EQ abap_true.
    ev_sonuc = abap_true.
  ELSE.
    ev_sonuc = abap_false.
  ENDIF.
ENDFUNCTION.
