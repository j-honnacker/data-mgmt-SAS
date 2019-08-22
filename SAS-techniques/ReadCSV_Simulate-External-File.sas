
filename ext_file temp;

data _null_;

	file
		ext_file
	;
	put
		'numeric,text'
		/'"Hello",1'
		/'"world!",2'
		/'"What''s going on",3'
	;
run;


data data1;

	infile
		data1
		dsd
		truncover
		firstobs=2
	;
	input
		numeric :$15.
		text    :3.
	;
run;