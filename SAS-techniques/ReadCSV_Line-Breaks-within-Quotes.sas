
/* Location of (original) input file
*/
%let original_file = /sas/homes/data/winemag-data-130k-v2.csv;


/* Create temporary file '_temp' */
filename _temp temp;

data _null_;

/*--- @ compile time ---------------------------------------------------------*/

	/* specify INPUT file for INPUT statement */
	infile
  		"&original_file."
  		lrecl = 32767
	;
	
	/* specify OUTPUT file for PUT statement: temporary file '_temp' */
	file
		_temp
	;

/*---- @ execution time ------------------------------------------------------*/

	/* read line from original file */
	input;

	/* count number of quotes occured so far (incl. the ones in current line) */
	quotes +countc(_infile_, '"');
	
	if mod(quotes, 2) then do;
	/*Odd number of quotes indicates an unexpected line break*/
	
		put
			_infile_ /*Write the current line...         */
			' '      /*...followed by a blank to '_temp'.*/
			@        /*Hold the pointer behind the blank => next PUT statement*/
		;            /*writes to the same line starting after the blank.      */
		
	end;
	else do;
		put
			_infile_  /*Write the current line to '_temp'.*/
		;             /*No '@' => next PUT statement writes to the next line.*/
	end;

run;


/* Print first 5 rows (+ haeder) of '_temp' to the log
*/
data _null_;
	infile
		_temp
		obs   = 6
		lrecl = 32767
	;
	input;
	list;
run;


/* Finally, read from the pre-processed '_temp' (instead of the original file)
*/
data wine;

	infile
		_temp
		truncover
		dsd
		firstobs = 2
		lrecl    = 977
		end      = eof
	;


	input
		index                 :6.
		country               :$22.
		description           :$829.
		designation           :$95.
		points                :3.
		price                 :6.1
		province              :$31.
		region_1              :$50.
		region_2              :$50.
		taster_name           :$18.
		taster_twitter_handle :$16.
		title                 :$140.
		variety               :$35.
		winery                :$56.
	;

run;



%macro determine_column_lengths;
/* This code was used to determine the column lengths. */

data _wine_column_lengths;

	infile
		_temp
		truncover
		dsd
		firstobs = 2
		lrecl    = 978
		end      = eof
	;

	do until(eof);

		input
			index                 :$7.
			country               :$23.
			description           :$830.
			designation           :$96.
			points                :$4.
			price                 :$7.
			province              :$32.
			region_1              :$51.
			region_2              :$18.
			taster_name           :$19.
			taster_twitter_handle :$17.
			title                 :$141.
			variety               :$36.
			winery                :$57.
		;

		max_index       = max(max_index      , lengthn(index));
		max_country     = max(max_country    , lengthn(country));
		max_description = max(max_description, lengthn(description));
		max_designation = max(max_designation, lengthn(designation));
		max_points      = max(max_points     , lengthn(points));
		max_price       = max(max_price      , lengthn(price));
		max_province    = max(max_province   , lengthn(province));
		max_region_1    = max(max_region_1   , lengthn(region_1));
		max_region_2    = max(max_region_2   , lengthn(region_2));
		max_taster_name = max(max_taster_name, lengthn(taster_name));
		max_taster_twitter_handle = max(max_taster_twitter_handle
		                               , lengthn(taster_twitter_handle));
		max_title       = max(max_title      , lengthn(title));
		max_variety     = max(max_variety    , lengthn(variety));
		max_winery      = max(max_winery     , lengthn(winery));
	end;

	keep max_:;

run;

%mend;
