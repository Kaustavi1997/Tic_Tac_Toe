#! /bin/bash 
declare -a matrix
NUMBER_OF_ROWS=3
NUMBER_OF_COLUMNS=3
playerSymbol=-1
computerSymbol=-1
toss=-1

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
getToss(){
	toss=$((RANDOM%2))
	if [ $toss -eq 0 ]
	then	
		echo "Player starts"
	else
		echo "Computer starts"
	fi
}
getIndex(){
	local i=$1
	local j=$2
	local linearIndex=$(($i*$NUMBER_OF_COLUMNS+$j))
	echo $linearIndex
}

showBoard(){
	local index=0
	for ((i=0;i<NUMBER_OF_ROWS;i++)) do
	    for ((j=0;j<NUMBER_OF_COLUMNS;j++)) do
	    	index=$(getIndex $i $j)
	        echo -n "${matrix[$index]}   "
	    done
	    echo
	    echo
	done
}
resetBoard
showBoard


