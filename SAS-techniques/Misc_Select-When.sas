
data test;

	length
		trigger    8
		answer   $13
		answer2  $13
	;

	trigger = 2;

	/* "select" without expression => flexible conditions
	*/
	select;
		when( mod( trigger, 2 ) ne 0 and trigger < 5 ) answer = "That's odd";
		when( mod( trigger, 2 ) eq 0 and trigger < 5 ) answer = "We're even";
		otherwise                                      answer = "Larger than 5";
	end;

	output;


	/* "select" with expression => only equal/in conditions
	*/
	select( trigger );
		when(1, 3, 5) answer = "Still odd";
		when(2, 4   ) answer = "Still even";
		otherwise     answer = "Still gt 5";
	end;

	output;


	/* execute multiple statements using a DO-END block:
	*/
	select( trigger );
		when(1, 3, 5) do;
			answer  = "Still odd";
			answer2 = "plus DO block";
			output;
		end;
		when(2, 4   ) do;
			answer  = "Still even";
			answer2 = "plus DO block";
			output;
		end;
		otherwise do;
			answer  = "Still gt 5";
			answer2 = "plus DO block";
			output;
		end;
	end;

run;