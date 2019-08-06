
data test_201812;
	data = "from Dec 2018";
run;

data test_201901;
	data = "from Jan 2019";
run;

data test_201902;
	data = "from Feb 2019";
run;


/*----------------------------------------------------------------------------*/
/*	PROC DATASETS
/*----------------------------------------------------------------------------*/

proc datasets
	nolist         /*suppress output*/
/*	library = work /*redundant because 'work' is the default (1)*/
;
	delete
		test_201812
		test_2019:  /*(2)*/
	;
run;
/*
	=> default libref is 'work' (1)
	=> colon wildcard can be used (2)
*/
