
/******************************************************************************/
/* xample data
/******************************************************************************/

data have;
	input
		data :$32.
	;
datalines;
cd_schufa_de201904_001
cd_schufa_de201904_002
cd_schufa_de201905_001
cd_schufa_de201905_002
rdm_20190701_de
rdm_20190701_se
rdm_20190702_de
rdm_20190702_se
rdm_20190703_de
rdm_20190703_se
cd_rdm_2017_all
cd_rdm_2018_all
old_one_1999
old_one_199912
old_one_19991230
run;



/******************************************************************************/
/*	Approach 1                                                                */
/******************************************************************************/

%let yyyy     = \d{4};  /*replace 4 digits with 'yyyy'     */
%let yyyymm   = \d{6};  /*replace 6 digits with 'yyyymmm'  */
%let yyyymmdd = \d{8};  /*replace 8 digits with 'yyyymmmdd'*/


/*----------------------------------------------------------------------------*/
/*	Perform approach 1 with a DATA step solution                              */
/*----------------------------------------------------------------------------*/

/*------------------------------*/
/* (1) Apply regular expression */
/*------------------------------*/
data approach_1;

    set have;

    data_clean = data;

    data_clean = prxchange("s/&yyyymmdd./<yyyymmdd>/", 1, data_clean);
    data_clean = prxchange("s/&yyyymm./<yyyymm>/"    , 1, data_clean);
    data_clean = prxchange("s/&yyyy./<yyyy>/"        , 1, data_clean);

run;

/*-----------------*/
/* (2) Filter data */
/*-----------------*/
proc sort
    data = approach_1
;
    by
        data_clean
        data
    ;
run;

data approach_1;

    set
        approach_1
    ;
    by
        data_clean
    ;
    if last.data_clean;
run;


/*----------------------------------------------------------------------------*/
/* Turn "DATA step solution" into an executable macro
/*----------------------------------------------------------------------------*/

%macro DATA_step_solution
(
	dsn_out    =
,	test_dates =
);

	/*------------------------------*/
	/* (1) Apply regular expression */
	/*------------------------------*/
	data &dsn_out.;

		set have;

		data_clean = data;

		%do i=1 %to %sysfunc(countw(&test_dates.));
		
			%let date_pattern     = &%scan(&test_dates., &i.).;
			%let date_replacement =  %scan(&test_dates., &i.);
		
			data_clean = prxchange("s/&date_pattern./<&date_replacement.>/"
			                      , 1, data_clean);
		%end;

	run;


	/*-----------------*/
	/* (2) Filter data */
	/*-----------------*/
	proc sort
		data = &dsn_out.
	;
		by
			data_clean
			data
		;
	run;

	data &dsn_out.;

		set
			&dsn_out.
		;
		by
			data_clean
		;
		if last.data_clean;
	run;

%mend;



/******************************************************************************/
/*	Approach 2                                                                */
/******************************************************************************/

%let yyyy     = 20\d\d;               /*2000     - 2099     => 'yyyy'    */
%let yyyymm   = 20\d\d[0-1]\d;        /*200000   - 209919   => 'yyyymm'  */
%let yyyymmdd = 20\d\d[0-1]\d[0-3]\d; /*20000000 - 20991939 => 'yyyymmdd'*/

%DATA_step_solution
(
	test_dates = yyyymmdd yyyymm yyyy
,	dsn_out    = approach_2
);



/******************************************************************************/
/*	Approach 3
/******************************************************************************/

%let yyyy_a = 1989;         /*1989      => 'yyyy'*/
%let yyyy_b = 199[0-9];     /*1990-1999 => 'yyyy'*/
%let yyyy_c = 20[0-2][0-9]; /*2000-2029 => 'yyyy'*/

%let yyyy = &yyyy_a.|&yyyy_b.|&yyyy_c.; /*1989-2029 => 'yyyy'*/


%let yyyymm_a = 19890[1-9];         /*1989 Jan-Sep*/
%let yyyymm_b = 19891[0-2];         /*1989 Oct-Dec*/
%let yyyymm_c = 199[0-9]0[1-9];     /*1990-1999, for each year: Jan-Sep*/
%let yyyymm_d = 199[0-9]1[0-2];     /*1990-1999, for each year: Oct-Dec*/
%let yyyymm_e = 20[0-2][0-9]0[0-9]; /*2000-2029, for each year: Jan-Sep*/
%let yyyymm_f = 20[0-2][0-9]1[0-2]; /*2000-2029, for each year: Oct-Dec*/

%let yyyymm = &yyyymm_a.|&yyyymm_b.|&yyyymm_c.|&yyyymm_d.|&yyyymm_e.|&yyyymm_f.;


%let yyyymmdd = &yyyymm_a.[0-3][0-9]|&yyyymm_b.[0-3][0-9]|&yyyymm_c.[0-3][0-9]|
                &yyyymm_d.[0-3][0-9]|&yyyymm_e.[0-3][0-9]|&yyyymm_f.[0-3][0-9];

%let yyyymmdd = %sysfunc(compress(&yyyymmdd.));

%DATA_step_solution
(
	test_dates = yyyymmdd yyyymm yyyy
,	dsn_out    = approach_3
);

