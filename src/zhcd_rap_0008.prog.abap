**&---------------------------------------------------------------------*
*& Report ZHCD_RAP_0008
**&---------------------------------------------------------------------*
**&
**&---------------------------------------------------------------------*
REPORT zhcd_rap_0008.
*
*TYPES: BEGIN OF LOTTO,
*        NUM TYPE INT2,
*      END OF LOTTO.
*
** Sorted table with unique key : Auto sorting & no duplication.
*" 1 Game.
*DATA: LT_GAME TYPE SORTED TABLE OF LOTTO
*      WITH UNIQUE KEY NUM WITH HEADER LINE.
*
*" 5 Game.
*DATA: BEGIN OF LT_5GAME OCCURS 0,
*       GAME LIKE TABLE OF LT_GAME,
*      END OF LT_5GAME.
*DATA: LS_GAME LIKE LINE OF LT_GAME.
*
*DATA: LV_CNT(1) TYPE N.
*
*DO 5 TIMES. " make 5 game.
*  CLEAR: LT_GAME, LT_GAME[], LT_5GAME, LV_CNT.
*
*  WHILE LV_CNT < 6. " get number until 6.
*
*     CALL FUNCTION 'RANDOM_I2'    " random function.
*     EXPORTING
*       RND_MIN         = 1
*       RND_MAX         = 45
*     IMPORTING
*       RND_VALUE       = LT_GAME-NUM.
*
*     INSERT TABLE LT_GAME.
*
*     LV_CNT = LINES( LT_GAME ). "number count
*
*  ENDWHILE.
*
*  LT_5GAME-GAME = LT_GAME[].
*  APPEND LT_5GAME.
*
*ENDDO.
*
*" display.
*LOOP AT LT_5GAME.
*  LOOP AT LT_5GAME-GAME INTO LS_GAME.
*
*   WRITE: LS_GAME-NUM  .
*  ENDLOOP.
*  WRITE /.
*ENDLOOP.

*data: l_cr(1) type c value cl_abap_char_utilites=>cr_lf,
*      l_lf(1) type c value cl_abap_char_utilities=>linefeed.
*
*  CONCATENATE '123' '345' INTO out SEPARATED BY l_cr.
*  CONCATENATE '333' '444' INTO out SEPARATED BY l_lf.


*DATA: v_line TYPE string.
*
*CONCATENATE 'LINE1' 'LINE2' INTO v_line SEPARATED BY cl_abap_char_utilities=>cr_lf.
*
*WRITE: v_line.

*DATA gv_daynr TYPE p.
*DATA gv_daytxt TYPE char15.
**DATA gv_dayfree TYPE char50.
*
*CALL FUNCTION 'J_3G_GET_DATE_DAYNAME'
*  EXPORTING
*    langu   = sy-langu
*    date    = sy-datum
**   CALID   =
*  IMPORTING
**    daynr   = gv_daynr
*    daytxt  = gv_daytxt
**    dayfree = gv_dayfree
** EXCEPTIONS
**   NO_LANGU                  = 1
**   NO_DATE = 2
**   NO_DAYTXT_FOR_LANGU       = 3
**   INVALID_DATE              = 4
**   OTHERS  = 5
*  .
*IF sy-subrc EQ 0.
** Implement suitable error handling here
*  WRITE:
*           gv_daytxt.
**           gv_dayfree.
*ENDIF.

* PARAMETERS: asd TYPE char50 LENGTH 5.

data: it_lfa1prog2 type STANDARD TABLE OF lfa1.
************************************************************************
START-OF-SELECTION.
* Select data
  select *
    UP TO 10 rows
    from lfa1
    into table it_lfa1prog2.
*Export data to memory using sy-uname as memory ID. When importing this
*data elsewhere you need to reference this same variable name.
  EXPORT it_lfa1prog2 to MEMORY ID sy-uname.
  WRITE: 'Zort!'.
