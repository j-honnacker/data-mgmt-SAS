/* (1) Print fmtsearch setting
       ....to figure out where SAS looks for formats */

/* - method 1 */
proc options option=fmtsearch;
run;

/* - method 2 */
%let _fmtsearch_options = %sysfunc(getoption(fmtsearch));
%put &_fmtsearch_options.;


/* (2) Get the path to the locations where SAS looks for formats */
%put %sysfunc(pathname(WORK));
/*%put %sysfunc(pathname(APFMTLIB));*/



/* Macro that was used for DI Studio jobs
   (when required formats where sitting in lib 'DI_FMTS')
*/
%macro _check_for_DI_fmts;

	%local _fmtsearch;

	/* save fmtsearch settings in macro variable &_fmtsearch */
	%let _fmtsearch = %sysfunc(getoption(fmtsearch));

	/* remove "()" from _fmtsearch */
	%let _fmtsearch = %sysfunc(compress(%superq(_fmtsearch), %str(%(%)) ));

	%if %sysfunc(findw(&_fmtsearch., DI_FMTS)) = 0 %then %do;
	/* If the library DI_FMTS is not a location where SAS looks for formats.. */
		
		/* ..then make it one! */
		options fmtsearch = ( &_fmtsearch. DI_FMTS );
		/* Note: New entries to fmtsearch are automatically set to upper case */

	%end;

%mend;

/*%_check_for_DI_fmts;*/