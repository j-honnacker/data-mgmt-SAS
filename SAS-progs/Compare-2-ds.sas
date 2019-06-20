data have_1;
	input
		id       :$3.
		var1     :$5.
		var_xtra :$2.
	;
datalines;
001 hello 01
002 how   03
002 how   03
002 how   03
003 you   05
004 doing 07
run;

data have_2;
	input
		id   :$3.
		var1 :$5.
	;
datalines;
001 hello
002 how
002 how
003 you
004 doing
run;

/******************************************************************************/


%macro compare_ds
(
	in_1 =
,	in_2 =
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
		                      rename = (VARNUM = VARNUM_&i.)
							)
	;
	run;
%end;

/* Compare variables by variable name
*/
data
	_tmp_vars_in_both   /*vars that exist in &in_1. and &in_2.*/
	_tmp_vars_only_in_1 /*vars that exist in &in_1. only*/
	_tmp_vars_only_in_2 /*vars that exist in &in_2. only*/
;

	merge
		_tmp_vars_1( in = in_1 )
		_tmp_vars_2( in = in_2 )
	;
	by
		NAME
	;

	if ( in_1 and in_2 ) then output _tmp_vars_in_both; /*var exists in both*/
	else do;
		if in_1 then output _tmp_vars_only_in_1; /*var exists in &in_1 only*/
		if in_2 then output _tmp_vars_only_in_2; /*var exists in &in_2 only*/
	end;
run;

/* Names of variables to compare => save in macro variable &vars_in_both
*/
proc sql noprint;
	select
		NAME
	into
		:vars_in_both separated by ' '
	from
		_tmp_vars_in_both
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

/* If &in_1 and &in_2 have no common variables => print to log and exit
*/
%if (&vars_in_both.) = () %then %do;
	%put WARNING: There are no variables to compare.;
	%return;
%end;

%mend;


%compare_ds
(
	in_1 = have_1
,	in_2 = have_2
);
