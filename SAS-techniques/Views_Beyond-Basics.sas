
/*----------------------------------------------------------------------------*/
/* Example data                                                               */
/*----------------------------------------------------------------------------*/

data tab_src;

	call streaminit(58840); /*set the seed for reproducible random numbers*/

	do year = 2018 to 2019;
		do store = "A", "B", "C";
			sales = rand('normal')*1e5;
			output;
		end;
	end;

	format sales dollarx12.;
run;



/*----------------------------------------------------------------------------*/
/* (1) Incorporate macro variables in views: Ampersand vs symget()/symgetn()  */
/*----------------------------------------------------------------------------*/

%let year = 2018;

/* Define view_1
*/
data view_1 / view = view_1;
	set tab_src
	(
		where = ( year = &year. ) /*incorporate &year. using ampersand*/
	);
run;

/* Define view_2
*/
data view_2 / view = view_2;
	set tab_src
	(
		where = ( year = symgetn('year') ) /*incorporate &year using symgetn()*/
	);
run;


/* set year variable to "2019" (before it was set to "2018")
*/
%let year = 2019;


/* Print view_1 to log (=> still shows data for 2018)
*/
title 'view_1';
proc print
	data = view_1;
run;

/* Print view_2 to log (=> shows data for 2019)
*/
title 'view_2';
proc print
	data = view_2;
run;

title;



/*----------------------------------------------------------------------------*/
/* (2) Define a view and a data set within the same DATA STEP                 */
/*----------------------------------------------------------------------------*/

data
	dsn_a(keep = year total_sales) /*"dsn_a": a DATA SET that stores data*/
	dsn_b(drop =      total_sales) /*"dsn_b": a VIEW that stores compiled code*/
/	view = dsn_b /*specify "dsn_b" as a view*/
;

	set tab_src;
	by year;

	format total_sales dollarx12.;
	total_sales + sales;

	if last.year then do;
		output dsn_a;
		total_sales = 0;
	end;

	output dsn_b;
run;


/*  Until this point, the code of the data step was compiled and stored in the
    view definition "dsn_b", but not executed.
     => The view definition "dsn_b" exists.
     => The data set "dsn_a" does NOT exist...
        ...until the view is used (and the code is executed).
*/


/* Print view 'dsn_b' to log (=> this also creates data set 'dsn_a')
*/
proc print
	data = dsn_b;
run;


/* Print data set 'dsn_a' to log
*/
proc print
	data = dsn_a;
run;
