*&---------------------------------------------------------------------*
*& Report ZHCD_RAP_0007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zhcd_rap_0007.

*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*PARAMETERS: p_sayi TYPE int4 OBLIGATORY.
*SELECTION-SCREEN END OF BLOCK b1.
*
*CALL FUNCTION 'ZHCD_F_ASAL_0001'
*  EXPORTING
*    iv_sayi           = p_sayi.
** IMPORTING
**   IV_SAYI_SON       =
*          .

TYPES: BEGIN OF gty_data,
         numara TYPE int4,
       END OF  gty_data,
       gtt_data TYPE TABLE OF gty_data.

DATA gt_data TYPE gtt_data.
DATA gs_data TYPE gtt_data.

DATA: i        TYPE int4,
      gv_sayi1 TYPE int4,
      gv_sayi2 TYPE int4,
      gv_sayi3 TYPE int4,
      gv_sayi4 TYPE int4,
      gv_sayi5 TYPE int4,
      gv_sayi6 TYPE int4,
      gv_tabix TYPE int4.

gv_tabix = 1.
DATA: ld_ranint TYPE qf00-ran_int,
      ld_maxint TYPE qf00-ran_int,
      ld_minint TYPE qf00-ran_int.

ld_minint = 1.
ld_maxint = 49.


*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
 CASE sy-ucomm.
 	WHEN '&EMN'.
    PERFORM lutu.
*   WHEN .
*   WHEN OTHERS.
 ENDCASE.
ENDMODULE.


START-OF-SELECTION.
  CALL SCREEN 0100.
*&---------------------------------------------------------------------*
*& Form LUTU
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM lutu .
DO 6 TIMES.
  CALL FUNCTION 'QF05_RANDOM_INTEGER'
    EXPORTING
      ran_int_max   = ld_maxint
      ran_int_min   = ld_minint
    IMPORTING
      ran_int       = ld_ranint
    EXCEPTIONS
      invalid_input = 1
      OTHERS        = 2.
*    WRITE:/ ld_ranint.
  IF  gv_tabix EQ 1.
    gv_sayi1 = ld_ranint.
  ELSEIF gv_tabix EQ 2.
    gv_sayi2 = ld_ranint.
  ELSEIF gv_tabix EQ 3.
    gv_sayi3 = ld_ranint.
  ELSEIF gv_tabix EQ 4.
    gv_sayi4 = ld_ranint.
  ELSEIF gv_tabix EQ 5.
    gv_sayi5 = ld_ranint.
  ELSEIF gv_tabix EQ 6.
    gv_sayi6 = ld_ranint.
  ENDIF.

  gv_tabix = gv_tabix + 1.
ENDDO.
ENDFORM.
