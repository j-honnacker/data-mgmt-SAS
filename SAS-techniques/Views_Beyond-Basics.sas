
/*----------------------------------------------------------------------------*/
/* Example data                                                               */
/*----------------------------------------------------------------------------*/

data tab_src;

	call streaminit(58840); /*set the seed for reproducible random numbers*/

	do year = 2018 to 2019;
		do store = "A", "B", "C";
			sales = rand('normal')*1e5;
			output;
		end;
	end;

	format sales dollarx12.;
run;


title;
/*----------------------------------------------------------------------------*/
/* Incorporate macro variables in views: Ampersand vs symget()/symgetn()      */
/*----------------------------------------------------------------------------*/

%let year = 2018;

/* Define view_1
*/
data view_1 / view = view_1;
	set tab_src
	(
		where = ( year = &year. ) /*incorporate &year. using ampersand*/
	);
run;

/* Define view_2
*/
data view_2 / view = view_2;
	set tab_src
	(
		where = ( year = symgetn('year') ) /*incorporate &year using symgetn()*/
	);
run;

title;
/* set year variable to "2019" (before it was set to "2018")
*/
%let year = 2019;


/* Print view_1 to log (=> still shows data for 2018)
*/
proc print
	data = view_1;
run;

/* Print view_2 to log (=> shows data for 2019)
*/
proc print
	data = view_2;
run;



