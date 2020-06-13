#! /bin/bash 
declare -a matrix
NUMBER_OF_ROWS=3
NUMBER_OF_COLUMNS=3
playerSymbol=-1
computerSymbol=-1

resetBoard(){
	for ((i=0;i<NUMBER_OF_ROWS;i++)) do
	    for ((j=0;j<NUMBER_OF_COLUMNS;j++)) do
	    	matrix+=(0)
	    done
	done
}
assignSymbol(){
	local check=$((RANDOM%2))
	if [ $check -eq 0 ]
	then
		playerSymbol="X"
		computerSymbol="O"
	else
		playerSymbol="O"
		computerSymbol="X"
	fi
	echo "Player's Symbol : $playerSymbol"
	echo "Computer's Symbol : $computerSymbol"
}
assignSymbol

