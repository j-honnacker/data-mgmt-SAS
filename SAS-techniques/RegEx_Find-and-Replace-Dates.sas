
/* xample data
*/
data _0_data_have;
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
/*	Solution 1                                                                */
/******************************************************************************/

%let date4 = \d{4};
%let date6 = \d{6};
%let date8 = \d{8};

data _1_simple_solution;

    set _0_data_have;

    data_clean = data;

    data_clean = prxchange("s/&date8./<ymd8>/", 1, data_clean);
    data_clean = prxchange("s/&date6./<ym6>/" , 1, data_clean);
    data_clean = prxchange("s/&date4./<y4>/" , 1, data_clean);

run;


proc sort
    data = _1_simple_solution
;
    by
        data_clean
        data
    ;
run;

data _1_simple_solution;

    set
        _1_simple_solution
    ;
    by
        data_clean
    ;
    if last.data_clean;
run;



/******************************************************************************/
/*	Solution 2                                                                */
/******************************************************************************/

%let date4 = 20\d\d;
%let date6 = 20\d\d[0-1]\d;
%let date8 = 20\d\d[0-1]\d[0-3]\d;

data _2_solution;

	set _0_data_have;

	data_clean = data;

	data_clean = prxchange("s/&date8./<ymd8>/", 1, data_clean);
	data_clean = prxchange("s/&date6./<ym6>/" , 1, data_clean);
	data_clean = prxchange("s/&date4./<ym4>/" , 1, data_clean);

run;


proc sort
    data = _2_solution
;
    by
        data_clean
        data
    ;
run;

data _2_solution;

    set
        _2_solution
    ;
    by
        data_clean
    ;
    if last.data_clean;
run;



/******************************************************************************/
/*	Solution 3
/******************************************************************************/

%let date4a = 20\d\d;
%let date4b = 19\d\d;
%let date4  = &date4a.|&date4b.;

%let date6a = 20\d\d[0-1]\d;
%let date6b = 19\d\d[0-1]\d;
%let date6  = &date6a.|&date6b.;

%let date8a = 20\d\d[0-1]\d[0-3]\d;
%let date8b = 19\d\d[0-1]\d[0-3]\d;
%let date8  = &date8a.|&date8b.;

data _3_solution;

	set _0_data_have;

	data_clean = data;

	data_clean = prxchange("s/&date8./<ymd8>/", 1, data_clean);
	data_clean = prxchange("s/&date6./<ym6>/" , 1, data_clean);
	data_clean = prxchange("s/&date4./<ym4>/" , 1, data_clean);

run;


proc sort
    data = _3_solution
;
    by
        data_clean
        data
    ;
run;

data _3_solution;

    set
        _3_solution
    ;
    by
        data_clean
    ;
    if last.data_clean;
run;

