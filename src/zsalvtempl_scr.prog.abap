*&---------------------------------------------------------------------*
*&  Include           ZSALVTEMP_SCR
*&---------------------------------------------------------------------*

selection-screen begin of block b1 with frame title gv_title.
select-options: so_carr1 for scarr-carrid,
                so_curr  for scarr-currcode.
selection-screen end of block b1.

at selection-screen output.
  gv_title = 'Parameter'.
  %_so_carr1_%_app_%-text = 'Carrier Code'.
  %_so_curr_%_app_%-text = 'Curr Code'.
