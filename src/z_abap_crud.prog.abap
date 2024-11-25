*&---------------------------------------------------------------------*
*& Report ZABAPCRUD
*&---------------------------------------------------------------------*
*& Lesson : CRUD (Create, Read, Update, Delete) internal table ABAP
*& Source : ABAPGeeks.com
*&---------------------------------------------------------------------*

report z_abap_crud.

data: it_scarr type table of scarr,
      wa_scarr like line of it_scarr.

*&-----------------------------------------------------------------
*& Create New Entry
*&-----------------------------------------------------------------
*& Create a line structure from the transparent table
*& fill all the columns with a new value
wa_scarr-carrid = 'EA'.
wa_scarr-carrname = 'Emirated Airline'.
wa_scarr-currcode = 'USD'.
wa_scarr-url = 'http://www.emirates.com'.
*& add the new single line of record into the table
insert scarr from wa_scarr.

wa_scarr-carrid = 'TA'.
wa_scarr-carrname = 'Turkish Airline'.
wa_scarr-currcode = 'USD'.
wa_scarr-url = 'http://www.turkishairlines.com'.
insert scarr from wa_scarr.

*&-----------------------------------------------------------------
*& Read entry from the table (Query)
*&-----------------------------------------------------------------
*& select single record into a working area (not internal table)
select single * into wa_scarr from scarr
  where carrid = 'TA'.

*& select records into an internal table
select * into table it_scarr
  from scarr
  where currcode = 'EUR'.
*& sy-subrc is a statement that indicates whether your syntax has been executed successfuly
if sy-subrc ne 0.
  message 'Carrier ID not found !' type 'I'.
endif.
*&-----------------------------------------------------------------
*& Update entry from the table
*&-----------------------------------------------------------------
*First we get the single record that we want to update
select single * into wa_scarr from scarr
  where carrid = 'TA'.

*And then we change the value
wa_scarr-currcode = 'EUR'.

*& To update a transparent table you use 2 ways
*& 1. UPDATE <TABLENAME> FROM <WORKING_AREA>.
update scarr from wa_scarr.
* 2. UPDATE <TABLENAME> SET <FIELD_TO_UPDATE> = <NEW_VALUE> WHERE <FIELD> = <VALUE>
*update scarr set currcode = 'EUR'
* where carrid = wa_scarr-carrid.

*&-----------------------------------------------------------------
*& Delete entry from the table
*&-----------------------------------------------------------------
*& Deleting a record is very straight forward
*& Just write DELETE FROM <TABLENAME> WHERE <FIELD> = <VALUE>

delete from scarr where carrid = 'TA'.
