
/*----------------------------------------------------------------------------*/
/* Example Data                                                               */
/*----------------------------------------------------------------------------*/
%macro xample_data;

	%do year = 2017 %to 2018;
		%do quarter = 1 %to 4;

			data sales_&year.q&quarter.;

				call streaminit(&year.&quarter.);

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
/* (1) DATA STEP View                                                         */
/*----------------------------------------------------------------------------*/

/* create view definition "view_2018": concatenate sales data sets of 2018
*/
data view_2018 / view = view_2018;
	set
		sales_2018q:
	;
run;


/* use "view_2018" to compute mean of variable "sales" for 2018
*/
proc summary data = view_2018;

	class store;
	var sales;

	output
		out  = summary ( drop = _:                /*drop redundant columns*/
		                 where = ( store ne "") ) /*drop "overall total" row*/
		mean = sales_mean
	;
run;



/*----------------------------------------------------------------------------*/
/* (2) PROC SQL VIEW                                                          */
/*----------------------------------------------------------------------------*/

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

