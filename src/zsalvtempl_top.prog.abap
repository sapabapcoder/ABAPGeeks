tables: scarr,sflight.

class zcl_salv_report definition deferred.
interface zif_salv_report.
  methods:
    set_pf_status
      changing
        co_alv type ref to cl_salv_table,
    set_layout
      changing
        co_alv type ref to cl_salv_table,
    set_top_of_page
      changing
        co_alv type ref to cl_salv_table,
    set_end_of_page
      changing
        co_alv type ref to cl_salv_table,
    set_display_setting
      changing
        co_alv type ref to cl_salv_table,
    set_columns
      changing
        co_alv type ref to cl_salv_table,
    set_functions
      changing
        co_alv type ref to cl_salv_table.
endinterface.

class zcl_salv_report definition.
  public section.

    interfaces: zif_salv_report.
    types: begin of typ_data,
             carrid   type scarr-carrid,
             carrname type scarr-carrname,
             connid   type sflight-connid,
             fldate   type sflight-fldate,
             currency type sflight-currency,
             price    type sflight-price,
           end of typ_data.

    types: tt_data type table of typ_data with default key.

    data: it_data type tt_data,
          wa_data type typ_data,
          gr_alv  type ref to cl_salv_table.  " ALV object reference

    methods:
      get_data,             " Method to retrieve data
      display_alv.          " Method to display ALV

endclass.

class zcl_salv_event_handler definition
                             inheriting from zcl_salv_report.
  public section.
    methods:
      constructor importing itab_ref type tt_data
                            salv_ref type ref to cl_salv_table,
      handle_click for event double_click of cl_salv_events_table
        importing row column,
      handle_link for event link_click of cl_salv_events_table
        importing row column,
      on_user_command for event added_function of cl_salv_events
        importing e_salv_function.

  private section.

    data: salv_table type ref to cl_salv_table,
          lt_data    type tt_data.

    data: lr_selections type ref to cl_salv_selections.

    data: lt_rows type salv_t_row,
          lt_cols type salv_t_column,
          ls_cell type salv_s_cell.

    data: l_row        type i,
          l_col        type lvc_fname,
          l_row_string type char128,
          l_col_string type char128,
          l_row_info   type char128,
          l_col_info   type char128.

endclass.
