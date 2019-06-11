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



/*----------------------------------------------------------------------------*/
/* t2.1: Create macro variables from the values of a data set variable using  */
/*       PROC SQL "into:" clause                                              */
/*----------------------------------------------------------------------------*/

proc sql noprint;

    select
        count(*)
    into
        :number_of_rows trimmed /*important: 'trimmed' removes leading blanks*/
    from
        xmpl_data
    ;
    /* NOTE: This is only to showcase the 'trimmed' option. To determine the
             number of rows of a SAS data set, instead of actually counting
             them, it's more efficient (1) to simply read the data set header
             (NOBS= data set option or SCL functions) or (2) to look up the data
             set infos in dictionary.tables. */
            
    select
        id
    ,   i   /*create macro variables from variable "i" also*/
    into
        :id_1-:id_&number_of_rows. /*the part after the hyphen is optional...*/
    ,   :i_1-                      /*...which is why this line also works*/
    from
        xmpl_data
    ;
quit;


%macro loop;

    /* iterate over all created macro variables "i_<i>" and "id_<i>" */
    %do i = 1 %to &number_of_rows.;

        /* print names and values of macro variables "i_<i>" and "id_<i>" */
        %put
        	i = &&i_&i..
        	id_&i. = &&id_&i..
        ;

    %end;

%mend;
%loop;



/*----------------------------------------------------------------------------*/
/* t2.2: Create a single macro variable containing all the values of a data   */
/*       set variable using PROC SQL "into:" clause                           */
/*----------------------------------------------------------------------------*/

proc sql noprint;
    select /*distinct  /* <- can be added to only consider unique id values*/
        id
    ,   i
    into
        :ids separated by ','
    ,   :i   separated by ', '
    from
        xmpl_data
    ;
quit;

/* print names and values of macro variable "id" and ids" */
%put &=i.;
%put &=ids.;

