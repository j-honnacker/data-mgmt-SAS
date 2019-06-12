
/*----------------*/
/* input data set */
/*----------------*/
data sales;
	input
		store      :$7.
		sales      :dollar5.
		product_ID :6.
	;
datalines;
store_B $100 900
store_B $120 544
store_C  $40 811
store_C $140 722
store_A $800 366
store_B  $80 099
run;



data
	sales_sorted( drop = stats: ) /*keep only input variables (w/o stats vars)*/
	sales_stats ( keep = stats: store ) /*keep only store + stats variables*/
;

	/*---------------------------------------------*/
	/* (1) DECLARE and INSTANTIATE hash 'hsh_main' */
	/*---------------------------------------------*/
	declare hash
		hsh_main(ordered:'a');       /*sort 'a'scending...*/
		hsh_main.DefineKey('store'); /*...by key vars (here: only 'store')*/
		hsh_main.DefineData('store'
		                   ,'stats_sales_cnt'
						   ,'stats_sales_max'
						   ,'stats_sales_avg'
						   ,'stats_sales_min'
		                   ,'hsh_sub' /*pointer to 'hsh_sub' hash instances...*/
						   ,'htr_sub' /*...and one to their iterators*/
		                   );
		hsh_main.DefineDone();
	declare hiter
		htr_main('hsh_main');

	/*---------------------------------------------------*/
	/* (2a) DECLARE (but not instantiate) hash 'hsh_sub' */
	/*---------------------------------------------------*/
	declare hash
		hsh_sub;
	declare hiter
		htr_sub;


	do until( done );

		set sales end=done;

		if hsh_main.find() ne 0 then do;

			/*--------------------------------------------*/
			/* (2b) INSTANTIATE a 'hsh_sub' hash instance */
			/*--------------------------------------------*/
			/* new hash instance */
			hsh_sub =
				_new_ hash(multidata:'y'
			              ,ordered:'d'  /*sort 'd'escending...*/
			              );
			hsh_sub.DefineKey('sales'); /*...by key vars (here: only 'sales')*/
			hsh_sub.DefineData('store'
			                  ,'sales'
							  ,'product_ID'
							  );
			hsh_sub.DefineDone();
			/* new hash iterator */
			htr_sub =
				_new_ hiter('hsh_sub');
			
			stats_sales_cnt = 1;
			stats_sales_max = sales;
			stats_sales_avg = sales;
			stats_sales_min = sales;
		end;
		else do;
			
			stats_sales_cnt +1;
			stats_sales_max = max(sales, stats_sales_max);
			stats_sales_avg = (stats_sales_avg*(stats_sales_cnt-1) + sales)/
			                   stats_sales_cnt;
			stats_sales_min = min(sales, stats_sales_min);
		end;

		hsh_main.replace(); /*add or replace in main hash instance*/
		hsh_sub.add();      /*add to sub hash instance*/

	end;

	do while(htr_main.next()=0);

		/*write a record to sales_stats*/
		output sales_stats;

		do while(htr_sub.next()=0);

			/*write a record to sales_sorted*/
			output sales_sorted;

		end;

		/*create dataset sales_<store>_sorted*/
		hsh_sub.output(dataset:catx('_', 'sales', store, 'sorted'));

	end;

	stop;
run;


