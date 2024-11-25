*&---------------------------------------------------------------------*
*&  Include           ZSALVTEMP_F01
*&---------------------------------------------------------------------*

class zcl_salv_report implementation.

  method display_alv.
    data: lx_msg type ref to cx_salv_msg.
    try.
        cl_salv_table=>factory(
            importing
              r_salv_table = gr_alv
            changing
              t_table      = it_data ) .
**********************************************************************
        "Report Saved Layout / Variant
**********************************************************************
        call method zif_salv_report~set_layout
          changing
            co_alv = gr_alv.
**********************************************************************
        "Report Header / Footer
**********************************************************************
        call method zif_salv_report~set_top_of_page
          changing
            co_alv = gr_alv.

*        call method zif_salv_report~set_end_of_page
*          changing
*            co_alv = gr_alv.
**********************************************************************
        "Display Setting (ALV Report Title, grid style)
**********************************************************************
        call method zif_salv_report~set_display_setting
          changing
            co_alv = gr_alv.
**********************************************************************
        "Columns settings / field catalog
**********************************************************************
        call method zif_salv_report~set_columns
          changing
            co_alv = gr_alv.
**********************************************************************
        "PF Status (Standard or custom)
**********************************************************************
*        call method zif_salv_report~set_pf_status
*          changing
*            co_alv = gr_alv.
**********************************************************************
        "Activate SALV Functions
**********************************************************************
        call method zif_salv_report~set_functions
          changing
            co_alv = gr_alv.
**********************************************************************
        "Handle Events from CL_SALV_EVENTS_TABLE
**********************************************************************

        data(cl_event) = new zcl_salv_event_handler( itab_ref = it_data
                                                     salv_ref = gr_alv  ).

        set handler: cl_event->handle_click for gr_alv->get_event( ),
                     cl_event->handle_link for gr_alv->get_event( ),
                     cl_event->on_user_command for gr_alv->get_event( ).

        "get reference of gt_data into cl_event->zif_salv_event~lr_data.
        "get reference of gr_alv into cl_event->zif_salv_event~ref_alv.

        data(selection) = gr_alv->get_selections( ).

        selection->set_selection_mode(  if_salv_c_selection_mode=>row_column ). "Single row selection

**********************************************************************

        gr_alv->display( ).

      catch cx_salv_msg into lx_msg.
    endtry.
  endmethod.
  method zif_salv_report~set_columns.

    data(orpt) = new zcl_salv_report( ).

    data: wa_data       type orpt->typ_data,
          ls_stru       type ref to cl_abap_structdescr,
          lt_ddfield_hd type ddfields.

    data: lo_cols   type ref to cl_salv_columns,
          lo_column type ref to cl_salv_column,
          lo_coltbl type ref to cl_salv_column_table.

    data: lo_functions            type ref to cl_salv_functions_list.
    data: lo_functional_settings  type ref to cl_salv_functional_settings.
    data: lo_tooltips type ref to cl_salv_tooltips,
          lv_value    type lvc_value.

    ls_stru ?= cl_abap_structdescr=>describe_by_data( p_data = wa_data ).
    lt_ddfield_hd = cl_salv_data_descr=>read_structdescr( ls_stru ).

    lo_cols = gr_alv->get_columns( ).

    "  lo_cols->set_optimize( 'X' ). "auto column width

    loop at lt_ddfield_hd into data(wa_field).
      try .

          lo_column = lo_cols->get_column( wa_field-fieldname ).
          lo_column->set_long_text( wa_field-scrtext_l ).
          lo_column->set_medium_text( wa_field-scrtext_m ).
          lo_column->set_short_text( wa_field-scrtext_s ).
          lo_column->set_output_length( wa_field-outputlen ).

        catch cx_salv_not_found.                        "#EC NO_HANDLER
      endtry.
    endloop.

**********************************************************************
**** Set column as icon,  set column as hotspot, add tooltip to column
**********************************************************************

         "Set Icon (set_icon)
*        lo_coltbl ?= lo_cols->get_column( 'ICONCOL' ) "min length 4 type c.
*        lo_coltbl->set_icon( if_salv_c_bool_sap=>true ).
*        lo_coltbl->set_long_text( 'Hover for Tooltip' ).
*        lo_coltbl->set_alignment( if_salv_c_alignment=>centered ).
*        lo_coltbl->set_output_length( 20 ).
*
*        "Set Hotspot (set_cell_type)
*        lo_coltbl ?= lo_cols->get_column( 'CARRID' ).
*        lo_coltbl->set_cell_type( if_salv_c_cell_type=>hotspot ).
*        lo_coltbl->set_alignment( if_salv_c_alignment=>centered ).
*        lo_coltbl->set_output_length( 20 ).

**********************************************************************
*** Set Tooltips for different icons
**********************************************************************

*        lo_functional_settings = co_alv->get_functional_settings( ).
*        lo_tooltips = lo_functional_settings->get_tooltips( ).
*
*        lv_value = icon_green_light.
*        lo_tooltips->add_tooltip(
*          type    = cl_salv_tooltip=>c_type_icon
*          value   = lv_value
*          tooltip = 'Started' ).                            "#EC NOTEXT
*
*        lv_value = icon_red_light.
*        lo_tooltips->add_tooltip(
*          type    = cl_salv_tooltip=>c_type_icon
*          value   = lv_value
*          tooltip = 'Not Started' ).                        "#EC NOTEXT

*      catch cx_salv_not_found.                          "#EC NO_HANDLER
*    endtry.
  endmethod.
  method zif_salv_report~set_display_setting.
    data: lo_display type ref to cl_salv_display_settings.

    lo_display = co_alv->get_display_settings( ).
*   set ZEBRA pattern
    lo_display->set_striped_pattern( 'X' ).
*   #SALVTITLE Title to ALV
    lo_display->set_list_header( 'Header Display Settings' ).
  endmethod.
  method zif_salv_report~set_end_of_page.
    data: lo_footer  type ref to cl_salv_form_layout_grid,
          lo_f_label type ref to cl_salv_form_label,
          lo_f_flow  type ref to cl_salv_form_layout_flow.
*
*   footer object
    create object lo_footer.
*
*   information in bold
    lo_f_label = lo_footer->create_label( row = 1 column = 1 ).
    lo_f_label->set_text( 'Footer Text' ).
*
*   tabular information
    lo_f_flow = lo_footer->create_flow( row = 2  column = 1 ).
    lo_f_flow->create_text( text = 'Another Text line in footer' ).
*
    lo_f_flow = lo_footer->create_flow( row = 3  column = 1 ).
    lo_f_flow->create_text( text = 'Another Text line in footer' ).
*
    lo_f_flow = lo_footer->create_flow( row = 3  column = 2 ).
    lo_f_flow->create_text( text = 1 ).
*
*   Online footer
    co_alv->set_end_of_list( lo_footer ).
*
*   Footer in print
    co_alv->set_end_of_list_print( lo_footer ).
  endmethod.
  method zif_salv_report~set_top_of_page.
    data: lo_header  type ref to cl_salv_form_layout_grid,
          lo_h_label type ref to cl_salv_form_label,
          lo_h_flow  type ref to cl_salv_form_layout_flow.
*
*   header object
    create object lo_header.
*
*   To create a Lable or Flow we have to specify the target
*     row and column number where we need to set up the output
*     text.
*
*   information in Bold
    lo_h_label = lo_header->create_label( row = 1 column = 1 ).
    lo_h_label->set_text( 'Header in Bold' ).
*
*   information in tabular format
    lo_h_flow = lo_header->create_flow( row = 2  column = 1 ).
    lo_h_flow->create_text( text = 'This is text of flow' ).
*
    lo_h_flow = lo_header->create_flow( row = 3  column = 1 ).
    lo_h_flow->create_text( text = 'Number of Records in the output' ).
*
    lo_h_flow = lo_header->create_flow( row = 3  column = 2 ).
    lo_h_flow->create_text( text = lines( it_data ) ).
*
*   set the top of list using the header for Online.
    co_alv->set_top_of_list( lo_header ).
*
*   set the top of list using the header for Print.
    co_alv->set_top_of_list_print( lo_header ).
  endmethod.

  method zif_salv_report~set_layout.
    data: lo_layout  type ref to cl_salv_layout,
          lf_variant type slis_vari,
          ls_key     type salv_s_layout_key.
*
*   get layout object
    lo_layout = co_alv->get_layout( ).
*
*   set Layout save restriction
*   1. Set Layout Key .. Unique key identifies the Differenet ALVs
    ls_key-report = sy-repid.
    lo_layout->set_key( ls_key ).
*   2. Remove Save layout the restriction.
    lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
*
*   set initial Layout
    lf_variant = 'DEFAULT'.
    lo_layout->set_initial_layout( lf_variant ).
  endmethod.
  method zif_salv_report~set_pf_status.
*   pf-status

    co_alv->set_screen_status(
      pfstatus      =  'SALV_STANDARD'
      report        =  'ZSALVTEMPL'
      set_functions = co_alv->c_functions_all ).

  endmethod.
  method zif_salv_report~set_functions.
    data: lo_functions            type ref to cl_salv_functions_list.
* Functions
    lo_functions = co_alv->get_functions( ).
    lo_functions->set_all( abap_true ).
  endmethod.
  method get_data.
*---------------------------------------------*
*       D A T A   S E L E C T I O N           *
*---------------------------------------------*
    select a~carrid a~carrname b~connid b~fldate b~currency b~price
      from ( scarr as a
               inner join sflight as b on a~carrid = b~carrid )
      into table it_data
      where a~carrid in so_carr1
        and a~currcode in so_curr.

  endmethod.

endclass.

class zcl_salv_event_handler implementation.
  method constructor.
    super->constructor( ).
    salv_table = salv_ref.
    lt_data = itab_ref.
  endmethod.
  method on_user_command.

    if sy-ucomm = 'GET_SEL'.

      lr_selections = salv_table->get_selections( ).
      lt_rows = lr_selections->get_selected_rows( ).
*  lt_cols = lr_selections->get_selected_columns( ).
*  ls_cell = lr_selections->get_current_cell( ).
      if lt_rows is initial.
        message 'Please select a row first!' type 'I'.
        exit.
      endif.

      wa_data = lt_data[ lt_rows[ 1 ] ] .

    endif.
  endmethod.
  method handle_link.
    data(lv_msg_link) = |Link clicked on row: { row } and column: { column }|.
    wa_data = lt_data[ row ].
  endmethod.

  method handle_click.
    data(lv_msg_click) = |Double clicked on row: { row } and column: { column }|.
    wa_data = lt_data[ row ].
  endmethod.

endclass.
