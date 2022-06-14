*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZHCD_T0002......................................*
DATA:  BEGIN OF STATUS_ZHCD_T0002                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZHCD_T0002                    .
CONTROLS: TCTRL_ZHCD_T0002
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZHCD_T0002                    .
TABLES: ZHCD_T0002                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
