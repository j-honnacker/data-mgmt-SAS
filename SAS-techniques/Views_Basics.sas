
/*----------------------------------------------------------------------------*/
/* Example Data                                                               */
/*----------------------------------------------------------------------------*/
%macro xample_data;

	%do year = 2017 %to 2018;
		%do quarter = 1 %to 4;

			data sales_&year.q&quarter.;

				/*set the seed for reproducible randomness*/
				call streaminit(&year.&quarter.);

				/*compute (random) sales for stores "A", "B", and "C"*/
				do store = "A", "B", "C";
					sales = abs(rand('normal')*1e5);
					output;
				end;

				format sales dollar12.2;
			run;
		
		%end;
	%end;

%mend;
%xample_data;


/*----------------------------------------------------------------------------*/
/* Calculate the average sales for each store for the year 2018 using         */
/*  (1) a PROC SQL In-line View                                               */
/*  (2) a DATA STEP View                                                      */
/*  (3) a PROC SQL View                                                       */
/*----------------------------------------------------------------------------*/

/*---------------------------*/
/* (1) PROC SQL In-line View */
/*---------------------------*/

proc sql;

	create table
		summary
	as
		select
			store
		,	mean(sales) as sales_mean format=dollar12.2
		from
		/* CREATE + USE In-Line View: concatenate sales data sets of 2018
		*/
		(
			select * from sales_2018q1
			union all
			select * from sales_2018q2
			union all
			select * from sales_2018q3
			union all
			select * from sales_2018q4
		)
		group by
			store
	;
quit;


/*--------------------*/
/* (2) DATA STEP View */
/*--------------------*/

/* create view definition "view1_2018": concatenate sales data sets of 2018
*/
data view1_2018 / view = view1_2018;
	set
		sales_2018q:
	;
run;


/* print view definition to log
*/
data view = view1_2018;
	describe;
run;


/* use "view1_2018" to compute mean of variable "sales" for 2018
*/
proc summary data = view1_2018;

	class store;
	var sales;

	output
		out  = summary1 ( drop = _:                /*drop redundant columns*/
		                  where = ( store ne "") ) /*drop "overall total" row*/
		mean = sales_mean
	;
run;


/*-------------------*/
/* (3) PROC SQL VIEW */
/*-------------------*/

/* create view definition "view2_2018": concatenate sales data sets of 2018
*/
proc sql;

	create view
		view2_2018
	as
		select
			*
		from
		(
			select * from sales_2018q1
			union all
			select * from sales_2018q2
			union all
			select * from sales_2018q3
			union all
			select * from sales_2018q4
		)
	;
quit;


/* print view definition to log
*/
proc sql;
	describe view view2_2018;
quit;


/* use "view2_2018" to compute mean of variable "sales" for 2018
*/
proc summary data = view2_2018;

	class store;
	var sales;

	output
		out  = summary2 ( drop = _:                /*drop redundant columns*/
		                  where = ( store ne "") ) /*drop "overall total" row*/
		mean = sales_mean
	;
run;

