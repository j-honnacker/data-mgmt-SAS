/* create an example data set with random 4-digit id values */
data xmpl_data;
    call streaminit(58840); /*make sure same random values are used each time*/
    do i = 1 to 10;
        id = put(rand('uniform')*1E4, z4.);
        output;
    end;
run;



/*----------------------------------------------------------------------------*/
/* t1: Create macro variables from the values of a data set variable using    */
/*     CALL SYMPUTX()                                                         */
/*----------------------------------------------------------------------------*/

data _null_;

    /* read only variable "id" from "xmpl_data" */
    set xmpl_data(keep=id) end=eof;

    /* save the value of variable "id" of row _N_ in a macro variable named
       "id_<_N_>" */
    call symputx( cats('id_', _N_) /*name of macro variable*/
                , id               /*value of macro variable*/
                );

    /* at the end of the file... */
    if eof;

    /* ...save the number of created "id_<i>" variables in macro macro variable
       "number_of_ids" */
    call symputx( 'number_of_ids'  /*name of macro variable*/
                , _N_              /*value of macro variable*/
                );
run;

/* print name and value of macro variable "number_of_ids" */
%put &=number_of_ids.;

%macro loop;

    /* iterate over all created macro variables "id_<i>" */
    %do i = 1 %to &number_of_ids.;

        /* print name and value of macro variable "id_<i>" */
        %put id_&i. = &&id_&i..;

    %end;

%mend;
%loop;
