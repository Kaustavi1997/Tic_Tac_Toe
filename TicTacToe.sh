#! /bin/bash -x
declare -a matrix
NUMBER_OF_ROWS=3
NUMBER_OF_COLUMNS=3

resetBoard(){
	for ((i=0;i<NUMBER_OF_ROWS;i++)) do
	    for ((j=0;j<NUMBER_OF_COLUMNS;j++)) do
	    	matrix+=(0)
	    done
	done
}
resetBoard
