
/******************************************************************************/
/* Create  sample data                                                        */
/******************************************************************************/

data stocks;
	format
		date date11.
	;
	input
		date :date11.
		sym :$3.
		prc :3.
	;
datalines;
03-NOV-2019 APL 100
03-NOV-2019 BBB  20
04-NOV-2019 APL  95
04-NOV-2019 BBB  22
05-NOV-2019 APL 105
05-NOV-2019 BBB  24
06-NOV-2019 APL 110
06-NOV-2019 BBB  23
07-NOV-2019 APL 108
07-NOV-2019 BBB  21
run;


/******************************************************************************/
/* T1: Populate a hash table                                                  */
/******************************************************************************/

%let condition = ( '04-NOV-2019'd <= date <= '06-NOV-2019'd );

data _null_;

	/* Define variables in PDV (during compile time) before declaring them in
	   hash tables. */
	if 0 then set stocks;
	/* if 0 => SET statement does not get executed (during execution time) */


	/*------------------------------------------------------------------------*/
	/* T1.1: Populate hash table "directly"                                   */
	/*------------------------------------------------------------------------*/

	/*-----------------------------------------*/
	/* (1) Declare and (2) populate hash table */
	/*-----------------------------------------*/
	declare hash
		hsh_1(dataset:"stocks(where=(&condition.))",
		      ordered:'a');
		hsh_1.defineKey('sym','date');
		hsh_1.defineData(all:'y');
		hsh_1.defineDone();
	/* - When populating the hash table, data set options (here, a WHERE=
	     condition) can be used.
	   - ordered:'a' => the hash table will be sorted by the key variables
	     (here, "sym" and "date") in 'a'csending order.
	   - all:'y' => all variables from the data set will be stored in the
	     hash table */

	/* Output hash table */
	hsh_1.output(dataset:'sorted_by_stocks1a');


	/*-------------------------------------------------------------------------/
	/* T1.2: Populate hash table "indirectly"                                 */
	/*-------------------------------------------------------------------------/

	/*------------------------*/
	/* (1) Declare hash table */
	/*------------------------*/
	declare hash
		hsh_2(ordered:'a');
		hsh_2.defineKey('sym','date');
		hsh_2.defineData('date','sym','prc');
		hsh_2.defineDone();
	/* - Here, each variable for the hash table needs to be specified.
	     all:'y' only works if a data set is given in the declaration of
	     the hash. */

	/*-------------------------*/
	/* (2) Populate hash table */
	/*-------------------------*/
	/* Loop through the data set until the end of file is reached */
	do until(eof);

		/* Read the next entry of the data set into the PDV */
		set stocks(where=(&condition.)) end = eof;

		/* Write PDV to hash table */
		hsh_2.add();
	end;

	/* Output hash table */
	hsh_2.output(dataset:'sorted_by_stocks1b');

	stop;
run;



/******************************************************************************/
/* T2: Use a hiter to iterate through the hash table                          */
/******************************************************************************/

data sorted_by_stocks2a sorted_by_stocks2b;

	if 0 then set stocks;

	/*---------------------------------*/
	/* Declare and populate hash table */
	/*---------------------------------*/
	declare hash
		hsh(dataset:"stocks(where=(&condition.))",
		    ordered:'a');
		hsh.defineKey('sym','date');
		hsh.defineData(all:'y');
		hsh.defineDone();

	/*---------------*/
	/* Declare Hiter */
	/*---------------*/
	declare hiter htr('hsh');


	/*----------------------------------------*/
	/* Iterate FORWARD through the hash table */
	/*----------------------------------------*/

	/* Start a loop by reading the FIRST entry of the hash table into the PDV...
	   ...and keep the loop alive as long as the return code rc is 0. */
	do rc = htr.first() by 0 while(rc = 0);

		/* Write PDV to data set */
		output sorted_by_stocks2a;

		/* Try to read NEXT entry of hash table into PDV.
		   The return code will deviate from 0 if there is no next entry. */
		rc = htr.next();
	end;


	/*------------------------------------------*/
	/* Iterate BACKWARDS through the hash table */
	/*------------------------------------------*/

	/* Start a loop by reading the LAST entry of the hash table into the PDV...
	   ...and keep the loop alive as long as the return code rc is 0. */
	do rc = htr.last() by 0 while(rc = 0);

		/* Write PDV to data set */
		output sorted_by_stocks2b;

		/* Try to read PREVIOUS entry of hash table into PDV.
		   The return code will deviate from 0 if there is no previous entry. */
		rc = htr.prev();
	end;


	drop rc;
	stop;
run;
