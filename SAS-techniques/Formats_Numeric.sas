
data test;

	number_00 = 123000.145;
	number_01 = number_00;
	number_02 = number_00;
	number_03 = number_00;

	format
		number_00
			      32.  /* =>  6 digits:
				              - 6 integers */
		number_01
			      32.2 /* =>  9 digits:
				              - 6 integers
				              - 1 decimal point
				              - 2 decimals */
		number_02
			dollar32.2 /* => 11 digits:
			                  - 1 leading dollar sign
			                  - 6 integers
			                  - 1 thousands delimiter (comma)
			                  - 1 decimal point
			                  - 2 decimals */
		number_03
			commax32.2 /* => 10 digits:
			                  - 6 integers
			                  - 1 thousands delimiter (point)
			                  - 1 decimal comma
			                  - 2 decimals */
	;

/*
	file
		"/sas/homes/data-mgmt-SAS/fmts_numeric_1.csv"
		dsd
	;

	put number_00 @;
	put number_01 @;
	put number_02 @;
	put number_03;


	file
		"/sas/homes/data-mgmt-SAS/fmts_numeric_2.csv"
		dsd
	;

	put number_00             @;
	put number_00       :32.2 @;
	put number_00 :dollar32.2 @;
	put number_00 :commax32.2;
*/

run;
