/*==============================================================================

file    : "QueryFlatFiles_Get-n-highest-lowest.sas"

author  : jh

created : 20190606

desc
----
	File contains definition of SAS macro %get_n_highest_lowest. The macro takes
	a flat file as input, identifies n records with the highest (lowest) values
	in certain variables, and writes these records to a SAS dataset. It requires
	only one pass through the flat file without	converting or sorting the whole
	file.

usage
-----
	- flat file required (here: stock_sentiment.txt) ---------------------------

		  Timestamp, Stock_ID, sentiment, relevance, more_vars
		10-AUG-2010,   stck_x,      0.65,      0.40, "ach"
		10-AUG-2010,   stck_Y,     -0.80,      0.30, "wie gut"
		10-AUG-2010,   stck_x,      0.50,      0.45, "dass niemand"
		11-AUG-2010,   stck_x,      0.40,      1.00, "weiss"

	- file containing column definitions for the flat file required
	  (here: stock_sentiment_def.txt)                               ------------

		 var_name, var_length, var_SAS_informat, var_SAS_format
		Timestamp,          8,         date11. ,     yymmddn8.
		Stock_ID ,         $8,              8.
		sentiment,          8,              5.2,            5.2
		relevance,          8,              5.2,            5.2
		more_vars,        $20,            $20.

		Note: Specifying a SAS format is optional (length and informat are
		      required).

	- sample execution ---------------------------------------------------------	

		%get_n_highest_lowest
		(
			infile     = stock_sentiment.txt
		,	infile_def = stock_sentiment_def.txt
		,	order_by   = sentiment
		,	n_highest  = 2
		);

==============================================================================*/




%macro get_n_highest_lowest
(
	infile     =
,	infile_def =
,	order_by   = /* <- tbd: make it work for >1 variable*/
,	n_highest  =
/*,	n_lowest   = /* <- tbd*/
);


/* read column definitions
*/
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

/* save column definitions in macro variables
*/
data _null_;
	set _column_def end=eof;
	call symputx(cats("var",_N_,"_name")    , var_name);
	call symputx(cats("var",_N_,"_length")  , var_length);
	call symputx(cats("var",_N_,"_informat"), var_SAS_informat);
	call symputx(cats("var",_N_,"_format")  , var_SAS_format);
	if eof;
	call symputx("number_of_vars", _N_);
run;

/* save column names as comma separated values in macro variable
*/
proc sql noprint;
	select
		var_name    /*select the values from "var_name"...*/
	into
		:var_names  /*...and store them into macro variable "var_names"*/
	separated by
		'", "'      /*insert quotation marks and a comma between the values*/
	from
		_column_def
	;
quit;

%let var_names = "&var_names.";  /*add "outer" quotations marks*/


data _null_;

	/* set variable attributes
	*/
	attrib

		/* input file variables */
	  %do i=1 %to &number_of_vars.;
		&&var&i._name.
			length = &&var&i._length.  /*set variable length*/
		  %if "&&var&i._format." ne "" %then %do;
			format = &&var&i._format.  /*set variable format (if available)*/
		  %end;
	  %end;

		/* temporary variables */
		__rc_ length = 8  /*will receive return codes from hash operations*/
	;

	/* instantiate hash table "hsh"
	*/
	declare hash
		hsh( multidata:'y'  /*allow duplicate key values*/
		   , ordered:'d' ); /*order by key variable(s) (descending)*/
		hsh.DefineKey("&order_by.");
		hsh.DefineData(&var_names.);
		hsh.DefineDone();

	/* instantiate hash iterator "htr" for hash table "hsh"
	*/
	declare hiter
		htr('hsh');

	/* specify how the input file will be read
	*/
	infile
		"&infile."  /*full path of input file*/
		firstobs=2  /*start with 2nd record (assumes a header in 1st record)*/
		dsd         /*settings for csv*/
		truncover   /*settings for missing/short values*/
		end=eof     /*variable indicating end of input file*/
	;
	
	/* loop through the records of the input file
	*/
	do until(eof);

		/* read record from input file
		*/
		input
		  %do i=1 %to &number_of_vars.;
			&&var&i._name.
				:&&var&i._informat.
		  %end;
		;
	
		/* add (input file) record to hash table
		*/
		hsh.add();

		/* remove last entry in hash if maximum number of entries is exceeded
		*/
		if hsh.num_items > &n_highest. then do;
			htr.last();       /*set pointer to last entry*/
			__rc_=htr.next(); /*clear the pointer so the entry can be removed*/
			hsh.remove();     /*remove entry*/
		end;

	end;

	/* create dataset from hash table
	*/
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
,	order_by    = sentiment /* <- tbd: make it work for >1 variable*/
,	n_highest   = 2
/*,	n_lowest    = 2 /* <- tbd*/
);



