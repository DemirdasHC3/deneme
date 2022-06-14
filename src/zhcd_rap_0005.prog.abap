*&---------------------------------------------------------------------*
*& Report ZHCD_RAP_0005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zhcd_rap_0005.

SELECTION-SCREEN BEGIN OF BLOCK sel_screen_1 WITH FRAME TITLE TEXT-000.
PARAMETERS : pa_matnr LIKE mara-matnr  MODIF ID id1,
             pa_ersda LIKE mara-ersda  MODIF ID id1,
             pa_ernam LIKE mara-ernam  MODIF ID id1.
SELECTION-SCREEN END OF BLOCK sel_screen_1.

************************************************************************
*Second Selection Screen                                               *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK sel_screen_2 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_matkl LIKE mara-matkl  MODIF ID id2,
             p_mtart LIKE mara-mtart  MODIF ID id2,
             p_aenam LIKE mara-aenam  MODIF ID id2.
SELECTION-SCREEN END OF BLOCK sel_screen_2.

************************************************************************
* Change Selection Screen Parameter                                    *
************************************************************************
SELECTION-SCREEN: BEGIN OF BLOCK change_screen.
PARAMETERS p_change AS CHECKBOX DEFAULT space USER-COMMAND id1.
SELECTION-SCREEN: END OF BLOCK change_screen.

************************************************************************
* Screen Active or Invisible Control Constants                         *
************************************************************************
CONSTANTS : c_selected TYPE c VALUE '1',
            c_canceled TYPE c VALUE '0'.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'ID1'.
        IF p_change IS  INITIAL.
          screen-invisible = c_canceled.
          screen-active    = c_selected.
          screen-required  = 2.
          MODIFY SCREEN.
          CLEAR : p_matkl,p_mtart ,p_aenam.
        ELSE.
          screen-invisible = c_selected .
          screen-active    = c_canceled .
          screen-required  = 2 .
          MODIFY SCREEN.
          CLEAR : pa_ernam,pa_ersda ,pa_matnr.
        ENDIF.
      WHEN 'ID2'.
        IF p_change  IS  INITIAL.
          screen-invisible = c_selected.
          screen-active    = c_canceled .
          MODIFY SCREEN.
        ELSE.
          screen-invisible = c_canceled.
          screen-active    = c_selected.
          screen-required  = 2.
          MODIFY SCREEN.
        ENDIF.
    ENDCASE.
  ENDLOOP.
