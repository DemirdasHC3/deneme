*&---------------------------------------------------------------------*
*& Include          ZHCD_RAP_0010_MDL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR 'TITLE_0100'.
  PERFORM drop_down.
  PERFORM set_screen.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
*  CLEAR:gv_chc.
  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&EXIT'.
      LEAVE PROGRAM.
    WHEN '&CKL'.
      CHECK gv_check = ''.
      IF  gv_adet2 EQ 0 AND gt_game2 IS NOT INITIAL.
*      PERFORM oynanan_sayi.
        PERFORM kazanan_sayi.
        PERFORM kontrol.
        IF gv_kazan NE 0.
          gv_bakiye = gv_bakiye + gv_kazan.
        ENDIF.
        gv_chc = abap_true.
      ELSE.
        MESSAGE 'Bilet alın ve Bilet numaralarını girin !' TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    WHEN '&BLTAL'.
      PERFORM bilet_adet.
      gv_chc = abap_false.
      gv_chc3 = abap_false.
    WHEN '&KYT'.
      IF gv_adet2 NE 0.
        PERFORM oynanan_sayi.
        CHECK gv_check = ''.
        gv_adet2 = gv_adet2 - 1.
      ENDIF.
    WHEN '&BILM'.
      PERFORM call_alv.
    WHEN '&PARA'.
      CLEAR gv_tutar.
      CALL SCREEN 0200 STARTING AT 10 08
                       ENDING AT 75 15.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
 SET PF-STATUS '0200'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
    CASE sy-ucomm.
    WHEN 'ENTER'.
      gv_bakiye = gv_tutar + gv_bakiye.
      LEAVE TO SCREEN 0.
    WHEN  'CANCEL'.
      LEAVE TO SCREEN 0.
     ENDCASE.
ENDMODULE.
