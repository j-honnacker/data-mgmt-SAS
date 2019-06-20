data have_1;
	input
		id       :$3.
		var1     :$5.
		var2     :2.
		var_xtra :$2.
	;
datalines;
001 hello 01 :)
002 how   03 :)
002 how   03 :)
002 how   03 :)
003 you   05 :)
004 doing 07 :)
run;

data have_2;
	input
		id   :$3.
		var1 :$5.
		var2 :$2.
	;
datalines;
001 hello 01
002 how   03
002 how   03
003 you   05
004 doing 07
run;

/******************************************************************************/


%macro compare_ds
(
	in_1       =
,	in_2       =
,	out_prefix = out
);

%local i;


/*----------------------------------------------------------------------------*/
/* Compare variables from &in_1 with those from &in_2                         */
/*----------------------------------------------------------------------------*/

/* Read variable information
*/
%do i=1 %to 2;
	proc contents noprint
		data = &&in_&i..
		out  = _tmp_vars_&i.( keep   =  NAME VARNUM type
		                      rename = (VARNUM = VARNUM_&i.
		                                TYPE   = TYPE_&i.)
							)
	;
	run;
%end;

/* Compare variables by variable name
*/
data
	_tmp_vars_in_both      /*for vars that exist in &in_1. and &in_2.*/
	_tmp_vars_only_in_1    /*for vars that exist in &in_1. only*/
	_tmp_vars_only_in_2    /*for vars that exist in &in_2. only*/
	_tmp_vars_dffrnt_types /*for same named vars of different types*/
;

	merge
		_tmp_vars_1( in = in_1 )
		_tmp_vars_2( in = in_2 )
	;
	by
		NAME
	;

	if ( in_1 and in_2 ) then do;
		if TYPE_1 = TYPE_2 then output _tmp_vars_in_both; /*var exists in both*/
		                   else output _tmp_vars_dffrnt_types;
	end;
	else do;
		if in_1 then output _tmp_vars_only_in_1; /*var exists in &in_1 only*/
		if in_2 then output _tmp_vars_only_in_2; /*var exists in &in_2 only*/
	end;
run;


proc sql noprint;

	/* Names of variables to compare => save in macro variable &vars_in_both
	*/
	select
		NAME
	into
		:vars_in_both separated by ' '
	from
		_tmp_vars_in_both
	;

	/* Same named variables of different types => save in &vars_dffrnt_types
	*/
	select
		NAME
	into
		:vars_dffrnt_types separated by ' '
	from
		_tmp_vars_dffrnt_types
	;
quit;


/* Names of variables that only exist in 1 of both data sets => print to log
*/
%let log_msg = %sysfunc(compbl(
	NOTE: Variables that will be excluded because they only exist in _:
));
%do i = 1 %to 2;
	data _null_;
		set _tmp_vars_only_in_&i.;
		
		if _N_ = 1 then do;
			log_msg = tranwrd("&log_msg.", "_:", "&&in_&i..:");
			put log_msg;
		end;

		log_msg = catx(" ", cats("(",_N_,")"), NAME);
		put log_msg;
	run;
%end;

/* Names of same named variables of different types => print to log
*/
%let log_msg = %sysfunc(compbl(
	NOTE: Variables that will be excluded because of differing types:
));
%do i=1 %to %sysfunc(countw(&vars_dffrnt_types.,' ,'));
	%if &i. = 1 %then %put &log_msg.;
	%put NOTE- (&i.) %scan(&&vars_dffrnt_types, &i.);
%end;

/* If &in_1 and &in_2 have no common variables => print to log and exit
*/
%if (&vars_in_both.) = () %then %do;
	%put WARNING: There are no variables to compare.;
	%return;
%end;


/*----------------------------------------------------------------------------*/
/* Compare records from &in_1 with those from &in_2                           */
/*----------------------------------------------------------------------------*/

/* Create sorted copies of both data sets for comparison
*/
%do i=1 %to 2;
	proc sort
		data = &&in_&i..(keep = &vars_in_both.)
		out  = _tmp_&i.
	;
		by
			_ALL_
		;
	run;

	data _tmp_&i.;
		retain __n;
		set _tmp_&i.;
		by
			&vars_in_both.
		;
		if first.%scan(&vars_in_both., -1) then __n=1;
		                                   else __n+1;
	run;

%end;

/* Compare sorted copies
*/
data
	&out_prefix._in_both    /*for records that exist in &in_1 and &in_2*/
	&out_prefix._only_in_1  /*for records that exist in &in_1 only*/
	&out_prefix._only_in_2  /*for records that exist in &in_2 only*/
;

	merge
		_tmp_1( in = _in_1 )
		_tmp_2( in = _in_2 )
	;
	by
		&vars_in_both.
		__n
	;

	if _in_1 and _in_2 then output &out_prefix._in_both; /*rec exists in both*/
	else if _in_1 then output &out_prefix._only_in_1; /*rec in &in_1 only*/
	              else output &out_prefix._only_in_2; /*rec in &in_2 only*/
run;


%mend;


%compare_ds
(
	in_1       = have_1
,	in_2       = have_2
,	out_prefix = result
);
