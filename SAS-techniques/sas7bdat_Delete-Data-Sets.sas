
%macro create_test_data;

	data test_201812;
		data = "from Dec 2018";
	run;

	data test_201901;
		data = "from Jan 2019";
	run;

	data test_201902;
		data = "from Feb 2019";
	run;

%mend;


/* create libref "my_lib" pointing to the same location as "work" */
libname my_lib "%sysfunc(pathname(work))";


/*----------------------------------------------------------------------------*/
/*	PROC DATASETS
/*----------------------------------------------------------------------------*/

%create_test_data;

proc datasets
	nolist         /*suppress output*/
/*	library = work /*redundant because 'work' is the default (1)*/
;
	delete
		test_201812
		test_2019:  /*(2)*/
	;
quit;
/*
	=> default libref is 'work' (1)
	=> colon wildcard can be used (2)
*/


/*----------------------------------------------------------------------------*/
/*	PROC DELETE
/*----------------------------------------------------------------------------*/

%create_test_data;

proc delete
	data =
		test_201812        /*(1)*/
		work.test_201901
		my_lib.test_201902 /*(2)*/
	;
run;
/*
	=> default libref is 'work' (1)
	=> possible to delete data sets from different librefs in one statement (2)
*/


/*----------------------------------------------------------------------------*/
/*	PROC SQL
/*----------------------------------------------------------------------------*/

%create_test_data;

proc sql;
	drop table
		test_201812        /*(1)*/
	,	work.test_201901
	,	my_lib.test_201902 /*(2)*/
	;
quit;
/*
	=> default libref is 'work' (1)
	=> possible to delete data sets from different librefs in one statement (2)
	=> multiple data set names must be separated by comma
*/
