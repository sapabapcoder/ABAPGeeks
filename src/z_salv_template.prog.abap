*&---------------------------------------------------------------------*
*& Report ZSALVTEMPL
*&---------------------------------------------------------------------*
*& Template Report For SALV Method
*& ABAPGeeks.com
*&---------------------------------------------------------------------*
report z_salv_template.
include zsalvtempl_top.
include zsalvtempl_scr.
include zsalvtempl_f01.

start-of-selection.
  data(o_alv) = new zcl_salv_report( ).
  o_alv->get_data( ).
  o_alv->display_alv( ).
