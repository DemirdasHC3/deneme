*&---------------------------------------------------------------------*
*& Include          ZHCD_RAP_0003_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
  PERFORM get_data. "Alv dataları için select
  PERFORM set_fcat. "Alv verilerinde düzenleme için
  PERFORM set_layout. "Alv tasarımı ve görünümü için

  IF go_grid IS INITIAL.
    CREATE OBJECT go_grid
      EXPORTING
        i_parent = cl_gui_container=>screen0.  " Parent Container
    CALL METHOD go_grid->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_fieldcatalog = gt_fcat
        it_outtab       = <dyn_table>.
  ELSE.
    CALL METHOD go_grid->refresh_table_display.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT *
    FROM zhcd_t0001
    INTO TABLE @gt_data.

  "Get_data ile aynı tipte çünkü illeri belirlememiz gerekiyor.
  gt_ilkodu = gt_data.
  SORT gt_ilkodu ASCENDING BY il_kodu.
  DELETE ADJACENT DUPLICATES FROM gt_ilkodu COMPARING il_kodu.

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
  DATA : lv_count     TYPE int4 VALUE 2, "colpos dolu olduğu için 2 verdik.
         lv_fieldname TYPE string,
         lv_ilkodu    TYPE string,
         lv_text      TYPE string.

  "---  Structure olmadığı için tek tel elle doldurduk.
  PERFORM build_fcat USING '1' 'MATNR' 'Malzeme' 'Malzeme' 'Malzeme'.

  "tabloda verileri dönderip fieldcatalogu doldurma..
  LOOP AT gt_ilkodu INTO DATA(ls_ilkodu).

    lv_ilkodu = ls_ilkodu-il_kodu. "fieldnamede String char bir değer istediği için tanımlama yaptık.

    CONCATENATE 'IL_KODU' lv_ilkodu INTO lv_fieldname SEPARATED BY '-'.    "Her kolon bazında fieldname tanımldık.
    CONCATENATE 'İl_Kodu' lv_ilkodu INTO lv_text SEPARATED BY '-'.         "Kısa orta uzun tanımlamalar için irleştirme yapıldı.

*** PERFORM build_fcat USING lv_count lv_fieldname  '' '' ''.
    PERFORM build_fcat USING lv_count lv_fieldname  lv_text lv_text lv_text. "kısa orta uzun tanımlar.
    lv_count = lv_count + 1 . "colposunu 1er artırarak devam edecek.

    CLEAR: lv_fieldname, lv_text.

  ENDLOOP.

  PERFORM create_dynamic_table.



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
  gs_layout-cwidth_opt = 'X'.
  gs_layout-zebra = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fcat  USING    p_col_pos
                          p_fieldname
                          p_scrtext_s
                          p_scrtext_m
                          p_scrtext_l.

  CLEAR gs_fcat. "structureyi doldurmadan önce veriyi temizle.
  gs_fcat-col_pos = p_col_pos.
  gs_fcat-fieldname = p_fieldname.
  gs_fcat-scrtext_s =  p_scrtext_s.
  gs_fcat-scrtext_m =  p_scrtext_m.
  gs_fcat-scrtext_l =  p_scrtext_l.

  "standart verilmesi gereken kod.
  IF gs_fcat-fieldname = 'MATNR'.
    gs_fcat-datatype = 'CHAR'.
    gs_fcat-intlen = 40.
  ELSE.
    gs_fcat-datatype = 'CHAR'.
    gs_fcat-intlen = 10.
  ENDIF.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DYNAMIC_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_dynamic_table .
  DATA : lv_fieldname TYPE string,
         lv_ilkodu    TYPE string.

  "--------------------------- Hazır ----------------------------
  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = gt_fcat
    IMPORTING
      ep_table        = go_table.

  ASSIGN go_table->* TO <dyn_table>.

  CREATE DATA gs_table LIKE LINE OF <dyn_table>.
  ASSIGN gs_table->* TO <gfs_table>.

  "-----------------------------------------------------------

  "Aynı tipte 3. tablo bu nedeni malzemeleri belirlemek.
  gt_malzeme = gt_data.
  SORT gt_malzeme BY matnr.
  DELETE ADJACENT DUPLICATES FROM gt_malzeme COMPARING matnr.

  "Malzemeleri belirlemek ve alv ye aktarmak gerekiyor.
  LOOP AT gt_malzeme INTO DATA(ls_malzeme).
    "Dump almamak için boş satır ekledik.
    APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_table>. "Dinamik tabloya boş satır ekle 'gfs_table' tipinde
    IF <gfs_table> IS ASSIGNED.
      ASSIGN COMPONENT 'MATNR' OF STRUCTURE <gfs_table> TO <gfs1>.
      IF <gfs1> IS ASSIGNED.
        <gfs1> = ls_malzeme-matnr.
      ENDIF.
    ENDIF.
    "Alv gelecek dinamik sütunları matnr ye göre belirleyecek döngü.
    LOOP AT gt_data INTO DATA(ls_data) WHERE matnr = ls_malzeme-matnr.
      lv_ilkodu = ls_data-il_kodu.
      CONCATENATE 'IL_KODU' lv_ilkodu INTO lv_fieldname SEPARATED BY '-'.
      IF <gfs_table> IS ASSIGNED.
        "Fieldname'ler doluysa fiyatı doldur.
        ASSIGN COMPONENT lv_fieldname OF STRUCTURE <gfs_table> TO <gfs1>.
        IF <gfs1> IS ASSIGNED.
          <gfs1> = ls_data-fiyat.
          CONDENSE <gfs1>.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
ENDFORM.
