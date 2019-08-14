/* Original input file created in R:

x <- data.frame('chr' = c("Cause", NA, "compares...", NA, "compares", "to you"),
                'num' = c(5, 8, 8, 4, 0, NA))

write.csv(x, 'written_by_R.csv')

*/


/* Location of (original) input file written in and by R:
*/
%let original_file = /sas/homes/data/from_R.csv;


/* Create temporary file '_temp'
*/
filename _temp temp;


/* Determine number of variables
	(by counting comma separated elements in 1st row)
*/
data _null_;
	infile
  		"&original_file."
  		lrecl = 32767
  		obs = 1
  	;
	input;
	call symputx('number_of_vars', countw(_infile_, ',', 'q'));
run;


data _null_;

/*--- @ compile time ---------------------------------------------------------*/

	/* specify INPUT file for INPUT statement */
	infile
  		"&original_file."
  		lrecl = 32767
  		end   = eof
  		dsd
  		truncover
	;
	
	/* specify OUTPUT file for PUT statement: temporary file '_temp' */
	file
		_temp
		dsd
	;

	/* specify maximum length for a variable
	*/
	length var $1000 ;

/*---- @ execution time ------------------------------------------------------*/

	do i=1 to &number_of_vars.;
		input var @;
		if var='NA' then var='';
		put var @;
	end;
	put;

run;


/* Finally, read from the pre-processed '_temp' (instead of the original file)
*/
data x_DataFrame;

	infile
		_temp
		dsd
		truncover
		firstobs = 2
		lrecl    = 32767
		end      = eof
	;


	input
		index   :12.
		chr    :$12.
		num      :3.
	;

run;

