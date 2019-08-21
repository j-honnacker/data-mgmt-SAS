
/*----------------------------------------------------------------------------*/
/* Create input CSV file
/*----------------------------------------------------------------------------*/
/* Original CSV file created in R:

# Create DataFrame 'x' with a character variable and a numeric variable - both
#  containing missing values
x <- data.frame('chr' = c("Cause", NA, "compares...", NA, "compares", "to you"),
                'num' = c(5, 8, 8, 4, 0, NA))

# Export DataFrame 'x' to CSV file 'input.csv'
write.csv(x, 'input.csv', row.names=FALSE)

*/


/*----------------------------------------------------------------------------*/
/* (1) Create '_temp', a modified copy of the input CSV file
/*----------------------------------------------------------------------------*/

/* Location of the input CSV file (written in and by R):
*/
%let input_file = /sas/homes/data/input.csv;


/* Create filename '_temp' for the temporary copy of the original input file
*/
filename _temp temp;


/* Determine number of variables
	(by counting comma separated elements in 1st row)
*/
data _null_;
	infile
  		"&input_file."
  		lrecl = 32767
  		obs = 1
  	;
	input;
	call symputx('number_of_vars', countw(_infile_, ',', 'q'));
run;


/* Read from input CSV file, replace NAs by blanks, and write to '_temp'
*/
data _null_;

/*--- @ compile time ---------------------------------------------------------*/

	/* specify INPUT file for INPUT statement */
	infile
  		"&input_file."
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

	/* specify maximum length for a variable */
	length var $1000 ;

/*---- @ execution time ------------------------------------------------------*/

	do i=1 to &number_of_vars.;
		input var @;             /*read from input file*/
		if var='NA' then var=''; /*replace NAs by blanks*/
		put var @;               /*write to temporary file*/
	end;
	put;

run;


/*----------------------------------------------------------------------------*/
/* (2) Import from the pre-processed '_temp' (instead of the original CSV file)
/*----------------------------------------------------------------------------*/

data output;

	infile
		_temp
		dsd
		truncover
		firstobs = 2
		lrecl    = 32767
		end      = eof
	;


	input
		chr    :$12.
		num      :3.
	;

run;

