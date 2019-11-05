
data test;


/******************************************************************************/
/*	Dates
/******************************************************************************/

/*
	yyyymmdd => "yyyy-mm-dd"
	20191105 => "2019-11-05"
*/
a1_date_as_numbers = 20191105;
a2_date_as_char    = put(
                          input( put(a1_date_as_numbers, 8.), yymmdd8.)
                        , yymmdd10.
                        );


/*
	"yyyy-mm-dd" => yyyymmdd
	"2019-11-05" => 20191105
*/
b1_date_as_char    = "2019-11-05";
b2_date_as_numbers = input(
                            put(input(b1_date_as_char, yymmdd10.), yymmddn8.)
                          , 8.
                          );


/*
	"yyyy-mm-dd" => date
	"2019-11-05" => 21858 (days since 01-JAN-1960)
*/
c1_date_as_char = "2019-11-05";
c2_date         = input(b1_date_as_char, yymmdd10.);

format
	c2_date date11. /*display 21858 (days since 01-JAN-1960) as 05-NOV-2011*/
;



/******************************************************************************/
/*	IDs
/******************************************************************************/

/*
	1234 => "00001234"
*/
d1_id = 1234;
d2_id = put(d1_id, z8.);


/*
	"00001234" => 1234
*/
e1_id = "00001234";
e2_id = input(e1_id, 8.);


run;