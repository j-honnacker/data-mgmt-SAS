
* create a data set with 21 obs...
;
data _xample;

	* specify order of variables ;
	length
		i j 8
	;

	* set the seed for reproducible randomness ;
	call streaminit(40213);
	
	do j = 1 to 21;
		i = round(abs(rand('normal')),.1)*100;
		output;
	end;
run;

* ...and sort it!
;
proc sort
	data = _xample
;
	by
		i
		descending j
	;
quit;



* (1a) 'attrn' statement in a DATA step
;
data _null_;

	dsid = open('_xample');
	nobs = attrn(dsid, 'nlobs');
	nvar = attrn(dsid, 'nvars');
	sort = attrc(dsid, 'sortedby');
	done = close(dsid);
	
	line1 = catx(' ', 'number of obs....', nobs);
	line2 = catx(' ', 'number of vars...', nvar);
	line3 = catx(' ', 'sorted by........', sort);
	
	put line1;
	put line2;
	put line3;
run;


* (1b) 'attrn' statement outside of a DATA step
;
%let dsid = %sysfunc(open(_xample));
%let nobs = %sysfunc(attrn(&dsid., nlobs));
%let nvar = %sysfunc(attrn(&dsid., nvars));
%let sort = %sysfunc(attrc(&dsid., sortedby));
%let done = %sysfunc(close(&dsid.));

%put number of obs.... &nobs_1b.;
%put number of vars... &nvar_1b.;
%put sorted by........ &sort_1b.;


* (2a) sashelp.vtable
;
data test;
	set sashelp.vtable
	(	where=
		(	catx('.',libname,memname) ='WORK._XAMPLE'
		)
	);
	
	sort = scan('no, yes', lengthn(sorttype)+1);
	
	line1 = catx(' ', 'number of obs....', nobs);
	line2 = catx(' ', 'number of vars...', nvar);
	line3 = catx(' ', 'data set sorted..', sort);
	
	put line1;
	put line2;
	put line3;
run;


* (2b) dictionary.tables
;
proc sql noprint;
	select
		strip(put(nobs, best.))
	,	strip(put(nvar, best.))
	,	scan('no, yes', lengthn(sorttype)+1)
	into
		:nobs
	,	:nvar
	,	:sort
	from
		dictionary.tables
	where
		catx('.',libname,memname) ='WORK._XAMPLE'
	;
quit;

%put number of obs.... &nobs.;
%put number of vars... &nvar.;
%put data set sorted.. &sort.;


* (3) 'contents' procedure
;
proc contents
	noprint
	data = _xample
	out  = _info
;
run;

data _null_;

	set _info end=done;
	
	if done;
		
	nvar = varnum;
	sort = scan('no, yes', sorted+1);

	line1 = catx(' ', 'number of obs....', nobs);
	line2 = catx(' ', 'number of vars...', nvar);
	line3 = catx(' ', 'data set sorted..', sort);
	
	put line1;
	put line2;
	put line3;
run;


* (4) 'set' statement
;
data _null_;

	if 0 then set _xample(obs=1) nobs=nobs;
	
	line1 = catx(' ', 'number of obs....', nobs);

	put line1;
	
	call symputx('nobs', nobs);
	
	stop;
run;

%put number of obs.... &nobs.;

