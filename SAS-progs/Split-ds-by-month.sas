
%macro split_ds_by_month
(
	input_ds         =
,	datetime_var     =
,	output_ds_prefix =
);

%local i;


proc sql noprint;
	select
		month
	,	count(*)
	into
		:month_1-
	,	:number_of_months
	from
	(	select distinct
			put(datepart(&datetime_var.),yymmn6.) as month
		from
			&input_ds.
	)
	order by
		month
	;
quit;


data
	%do i = 1 %to &number_of_months.;
		&output_ds_prefix.&&month_&i..
		(
			where = ( put(datepart(&datetime_var.),yymmn6.) = "&&month_&i.." )
		)
	%end;
;
	set &input_ds.;
run;

%mend;



/*	Example  -----------------------------------------------------------------*/

data xample_data;

	format
		snapshot_dt datetime19.
	;
	input
		snapshot_dt :anydtdtm19.
		data        $21-48
	;
datalines;
31-01-2020 00:00:00 Data from January
29-02-2020 00:00:00 This happened in February...
29-02-2020 00:00:00 ...this too
31-03-2020 00:00:00 Already March...
31-03-2020 00:00:00 ...time flies!
run;


%split_ds_by_month
(
	input_ds         = xample_data
,	output_ds_prefix = xample_data_
,	datetime_var     = snapshot_dt
);
