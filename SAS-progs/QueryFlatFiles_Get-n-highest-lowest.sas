/*==============================================================================

file    : "QueryFlatFiles_Get-n-highest-lowest.sas"

author  : jh

created : 20190606

desc    : File contains definition of SAS macro %get_n_highest_lowest.

usage
-----	
	- flat file required (here: stock_sentiment.txt) ---------------------------

		Timestamp,Stock_ID,sentiment,relevance,more_vars
		10-AUG-2010,stck_x, 0.65,0.40,"ach"
		10-AUG-2010,stck_Y,-0.80,0.30,"wie gut"
		10-AUG-2010,stck_x, 0.50,0.45,"dass niemand"
		11-AUG-2010,stck_x, 0.40,1.00,"weiss"

	- file containing column definitions for the flat file required
	  (here: stock_sentiment_def.txt)                               ------------

		var_name,var_length,var_SAS_informat,var_SAS_format
		Timestamp,8,date11.,yymmddn8.
		Stock_ID,$8,$8.
		sentiment,8,5.2,5.2
		relevance,8,5.2,5.2
		more_vars,$20,$20.

	- sample execution ---------------------------------------------------------	

		%get_n_highest_lowest
		(
			infile     = stock_sentiment.txt
		,	infile_def = stock_sentiment_def.txt
		);

==============================================================================*/




%macro get_n_highest_lowest
(
	infile     =
,	infile_def =
,	order_by   =
);


/* read column definitions */
data _column_def;
	infile
		"&infile_def."
		dsd
		truncover
		firstobs=2
	;
	input
		var_name         :$32.
		var_length       : $8.
		var_SAS_informat :$32.
		var_SAS_format   :$32.
	;
run;

/* save column definitions in macro variables */
data _null_;
	set _column_def end=eof;
	call symputx(cats("var",_N_,"_name")    , var_name);
	call symputx(cats("var",_N_,"_length")  , var_length);
	call symputx(cats("var",_N_,"_informat"), var_SAS_informat);
	call symputx(cats("var",_N_,"_format")  , var_SAS_format);
	if eof;
	call symputx("number_of_vars", _N_);
run;

/* save column definitions in macro variables */
data _null_;
	set _column_def end=eof;
	call symputx(cats("var",_N_,"_name")    , var_name);
	call symputx(cats("var",_N_,"_length")  , var_length);
	call symputx(cats("var",_N_,"_informat"), var_SAS_informat);
	call symputx(cats("var",_N_,"_format")  , var_SAS_format);
	if eof;
	call symputx("number_of_vars", _N_);
run;

/* save column names as comma separated values in macro variable */
proc sql noprint;
	select
		var_name
	into
		:var_names
	separated by
		'", "'
	from
		_column_def
	;
quit;

%let var_names = "&var_names."; /*add "outer" quotations marks*/


data _null_;

	attrib
	  %do i=1 %to &number_of_vars.;
		&&var&i._name.
			length = &&var&i._length.  /*set variable length*/
		  %if "&&var&i._format." ne "" %then %do;
			format = &&var&i._format.  /*set variable format (if available)*/
		  %end;
	  %end;
	;

	declare hash
		hsh( multidata:'y'
		   , ordered:'d' );
		hsh.DefineKey("&order_by.");
		hsh.DefineData(&var_names.);
		hsh.DefineDone();

	infile
		"&infile."
		firstobs=2
		dsd
		truncover
		end=eof
	;
	
	do until(eof);
		input
		  %do i=1 %to &number_of_vars.;
			&&var&i._name.
				:&&var&i._informat.
		  %end;
		;
	
		hsh.add();

	end;

	hsh.output(dataset:'test');

	stop;
run;
	
%mend;



/*%let path_to_data = C:\D\repos\data-mgmt-SAS\SAS-progs\;*/
%let path_to_data =	/sas/homes/repos/data-mgmt-SAS/SAS-progs/;

%get_n_highest_lowest
(
	infile      = &path_to_data.stock_sentiment.txt
,	infile_def  = &path_to_data.stock_sentiment_def.txt
,	order_by    = sentiment
);



