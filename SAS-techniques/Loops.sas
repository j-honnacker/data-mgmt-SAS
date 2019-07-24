
/* xample daily data
*/
data data_20190627;
	var = "Data from Thursday";
run;

data data_20190628;
	var = "This happened Friday";
run;

data data_20190701;
	var = "It's finally Monday!";
run;


/* xample monthly data
*/
data data_201911;
	var = "Data from November";
run;

data data_201912;
	var = "This happened December";
run;

data data_202001;
	var = "It's finally January!";
run;


%macro loop_through_daily_data
(
    start =
,   end   =
);

    /* &start_num and &end_num contain dates as # of days (since 01-JAN-1960)
    */
	%let start_num = %sysfunc(inputn(&start., yymmdd8.));
	%let end_num   = %sysfunc(inputn(&end.  , yymmdd8.));

	/* &date_num will contain each date as # of days (since 01-JAN-1960)
	*/
	%do date_num = &start_num. %to &end_num.;

		/* &date_char will contain each date as <yyyymmddd>
		*/
		%let date_char = %sysfunc(putn(&date_num., yymmddn8.));

		/* Print dates to log
		*/
		%put &date_num. : &date_char.;


		/* Use &date_char. to look for daily data sets
		*/
		%if %sysfunc(exist(data_&date_char.)) %then %do;
		/* if data set exists... */

			/* ...process it!
			/* Here: Add new column 'weekday'
			*/
			data data_&date_char.;
				set data_&date_char.;
				weekday = scan(var, -1);
			run;

		%end;

	%end;

%mend;


%loop_through_daily_data
(
    start = 20190627
,   end   = 20190701
);



%macro loop_through_monthly_data
(
	start =
,	end   =
);

    /* &date_num and &end_num contain dates as # of days (since 01-JAN-1960)
    */
	%let date_num = %sysfunc(inputn(&start.01, yymmdd8.));
	%let end_num  = %sysfunc(inputn(&end.01  , yymmdd8.));

	/* Loop while current date (&date_num) is before or equal to the end date
	*/
	%do %while(&date_num. <= &end_num.);

		/* &date_char will contain each date as <yyyymm>
		*/
		%let date_char = %sysfunc(putn(&date_num., yymmn6.));

		/* Print dates to log
		*/
		%put &date_char. : &date_num.;


		/* Use &date_char. to look for monthly data sets
		*/
		%if %sysfunc(exist(data_&date_char.)) %then %do;
		/* if data set exists... */

			/* ...process it!
			/* Here: Add new column 'month'
			*/
			data data_&date_char.;
				set data_&date_char.;
				month = scan(var, -1);
			run;

		%end;


		/* Increase &date_num by 1 month
		*/
		%let date_num = %sysfunc(intnx(month, &date_num., 1, b));
	%end;


%mend;


%loop_through_monthly_data
(
	start = 201911
,	end   = 202001
);