*&---------------------------------------------------------------------*
*& Report ZHCD_RAP_0009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZHCD_RAP_0009.

data: it_lfa1prog1 type STANDARD TABLE OF lfa1,
      wa_lfa1      type lfa1.
************************************************************************
START-OF-SELECTION.
*Clear memory id
FREE MEMORY ID sy-uname.
*Execute Program 2
submit ZHCD_RAP_0008 and return.
************************************************************************
END-of-SELECTION.
*Import data from memory. Although the import statement must refrerence
*the same variable name the data was export with, the the local
*itab(it_lfa1prog2) where data is being imported too can have a
*different name (i.e. it_lfa1prog1).
import it_lfa1prog2 to it_lfa1prog1 from memory id sy-uname.
*Just for clarification if the the following lines of code were
*implemented it would pass a syntax check but would not retrieve any
*data as the importing field name is different to that exported.
***import it_data to it_lfa1prog1 from memory id sy-uname.
***import it_lfa1 to it_lfa1prog1 from memory id sy-uname.
*Display data
LOOP AT it_lfa1prog1 INTO WA_LFA1.
  write:/ WA_LFA1-LIFNR.
ENDLOOP.
