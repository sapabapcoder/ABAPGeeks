*&---------------------------------------------------------------------*
*& Report ZABAPDATATYPES
*&---------------------------------------------------------------------*
*& Lesson    : ABAP Data Types
*& Level     : ABAP Beginner
*& Tutor     : ABAPGeeks.com
*& Reference : https://abapgeeks.com/how-to-declare-various-data-types-in-abap/
*&---------------------------------------------------------------------*

report zabapdatatypes.

*&--------------------------------------------------------------------------*
* ABAP Elementary Data Type
*&--------------------------------------------------------------------------*
* Predefined SAP data types whose length are fixed
* such as c (character), i (integer), d (date field), t (time field)
* use the DATA statement to declare a variable that refers to the data types
* the syntax for Elementary Data Type is TYPE
*&---------------------------------------------------------------------------*

data lv_status type c. "The predefined data type c has an initial length 1.
data lv_name   type c length 20. "But you can also specify the length e.g: 20.
data lv_dob    type d. "d is used to store date field with format of YYYYMMDD.
data lv_age    type i. "i is used to store integer (whole number)
data lv_dec    type p decimals 2. "p is used to store decimal number, you can also add decimal points.
data lv_tim    type t. "t is used to store time field with format HHMMSS.

* To declare more that one variables, you can add colon (:) after the DATA statement
* this way you only need to use DATA statement once.
data: lv_a type c,
      lv_b type c length 10,
      lv_c type i.

* How to assign values to data objects (variables)
lv_status = 'A'.
lv_name = 'John Doe'.
lv_dob = '19881202'.
lv_tim = sy-uzeit. "this is an internal ABAP command to display current time
lv_dec = 100 / 3. "the result will have 2 decimal point

* You can display more than one values using WRITE: statement
write:/ '----------------------------------'.
write:/ 'Elementary Data Types'.
write:/ '----------------------------------'.
write:/ lv_status, lv_name, lv_dob, lv_tim, lv_dec.

skip 1. "Skip is used to add new line
*&--------------------------------------------------------------------------*
* Reference Types
*&--------------------------------------------------------------------------*
* We use reference type mostly for Object Oriented Programming
* to refer data objects to a class object
* the syntax for reference type is TYPE REF TO
*&---------------------------------------------------------------------------*

write:/ '----------------------------------'.
write:/ 'Reference Types'.
write:/ '----------------------------------'.

data: cl_cont type ref to cl_gui_custom_container.

* Instatiate the cl_cont object using CREATE OBJECT statement
create object cl_cont
  exporting
    container_name = 'CONT'.

if cl_cont is initial. "Check if the object created successfully
  write: / 'Object creation failed!'.
else.
  write: / 'Object created successfully!'.
endif.

skip 1.

write:/ '----------------------------------'.
write:/ 'ABAP Complex Data Types'.
write:/ '----------------------------------'.
*&--------------------------------------------------------------------------*
* ABAP Complex Data Types
*&--------------------------------------------------------------------------*
* Complex data types enable us to store multiple values in a single structure
* or store a records in a table
* the syntax for reference type is TYPE or TYPE TABLE OF
*&---------------------------------------------------------------------------*
skip 1.
write:/ '--------------------------------------'.
write: / '1. Structured Data Type (single row)'.
write:/ '--------------------------------------'.
*&------------------------------
*& 1. Structured Data Type
*&------------------------------
types:
  begin of typ_emp,
    emp_id type c length 3,
    emp_nm type c length 30,
    title  type c length 5,
  end of typ_emp.

data: wa_emp type typ_emp.

wa_emp-emp_id = 'E01'.
wa_emp-emp_nm = 'John'.
wa_emp-title = 'Mr'.

write:/ wa_emp-emp_id, wa_emp-title, wa_emp-emp_nm. "The values will be displayed as a single unit

skip 1.
write:/ '---------------------------------------------------'.
write: / '2. Table Type / Internal Table (internal table)'.
write:/ '---------------------------------------------------'.
*&------------------------------
*& 2. ABAP Complex Types
*&------------------------------
* You can also define a variable (data object) as a table using TABLE TYPE OF statement
* now you can have a table type using the typ_emp structure to store multiple records
data it_emp type table of typ_emp.

* Use APPEND statement to add entries to your TABLE type.
wa_emp-emp_id = 'E01'.
wa_emp-emp_nm = 'John'.
wa_emp-title = 'Mr'.
append wa_emp to it_emp.

wa_emp-emp_id = 'E02'.
wa_emp-emp_nm = 'George'.
wa_emp-title = 'Mr'.
append wa_emp to it_emp.

wa_emp-emp_id = 'E03'.
wa_emp-emp_nm = 'Susy'.
wa_emp-title = 'Mr'.
append wa_emp to it_emp.

wa_emp-emp_id = 'E04'.
wa_emp-emp_nm = 'Brian'.
wa_emp-title = 'Mr'.
append wa_emp to it_emp.

wa_emp-emp_id = 'E05'.
wa_emp-emp_nm = 'Eddy'.
wa_emp-title = 'Mr'.
append wa_emp to it_emp.

"Loop the entries of your internal table using the LOOP Statement
"Put the WRITE statement inside the LOOP statement to display each row
LOOP AT it_emp INTO wa_emp.
  write:/ wa_emp-emp_id, wa_emp-title, wa_emp-emp_nm.
ENDLOOP.
