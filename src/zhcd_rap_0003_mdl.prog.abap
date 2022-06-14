*&---------------------------------------------------------------------*
*& Include          ZHCD_RAP_0003_MDL
*&---------------------------------------------------------------------*

MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
* SET TITLEBAR 'xxx'.

  PERFORM display_alv.
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
