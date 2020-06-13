#! /bin/bash 
declare -a matrix
NUMBER_OF_ROWS=3
NUMBER_OF_COLUMNS=3
NEXT_TURN=0
WIN=1
TIE=2
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
checkRows(){
	local flag=0
	local rowFlag
	local firstElement
	for ((i=0;i<NUMBER_OF_ROWS;i++)) do
		firstElement=${matrix[$(getIndex $i 0)]}
		if [ $firstElement == 0 ]
		then
			continue
		fi

		rowFlag=0
	    for ((j=1;j<NUMBER_OF_COLUMNS;j++)) do
	    	if [ $firstElement != ${matrix[$(getIndex $i $j)]} ]
	    	then 
	    		rowFlag=1
	    		break
	    	fi
	    done
	    if [ $rowFlag -eq 0 ]
	    then
	    	flag=1
	    	break
	    fi
	done

	if [ $flag -eq 0 ]
	then
		echo 0
	else
		echo 1
	fi
}

checkColumns(){
	local flag=0
	local firstElement
	local colFlag
	for ((j=0;j<NUMBER_OF_COLUMNS;j++)) do
		firstElement=${matrix[$(getIndex 0 $j)]}
		if [ $firstElement == 0 ]
		then
			continue
		fi

		colFlag=0
	    for ((i=1;i<NUMBER_OF_ROWS;i++)) do
	    	if [ $firstElement != ${matrix[$(getIndex $i $j)]} ]
	    	then 
	    		colFlag=1
	    		break
	    	fi
	    done
	    if [ $colFlag -eq 0 ]
	    then
	    	flag=1
	    	break
	    fi
	done

	if [ $flag -eq 0 ]
	then
		echo 0
	else
		echo 1
	fi
}

checkMainDiagonal(){
	local flag=1
	local firstElement=${matrix[$(getIndex 0 0)]}
	if [ $firstElement != 0 ]
	then
		for ((i=1;i<NUMBER_OF_ROWS;i++)) do
	    	if [ $firstElement != ${matrix[$(getIndex $i $i)]} ]
	    	then 
	    		flag=0
	    		break
	    	fi
		done
	else
		flag=0
	fi

	if [ $flag -eq 0 ]
	then
		echo 0
	else
		echo 1
	fi
}

checkOffDiagonal(){
	local flag=1
	local firstElement=${matrix[$(getIndex 0 $(($NUMBER_OF_ROWS-1)))]}
	if [ $firstElement != 0 ]
	then
		for ((i=1;i<NUMBER_OF_ROWS;i++)) do
	    	if [ $firstElement != ${matrix[$(getIndex $i $(($NUMBER_OF_ROWS-1-$i)))]} ]
	    	then 
	    		flag=0
	    		break
	    	fi
		done
	else
		flag=0
	fi

	if [ $flag -eq 0 ]
	then
		echo 0
	else
		echo 1
	fi
}

checkTie(){
	local flag=1
	for ((i=0;i<NUMBER_OF_ROWS;i++)) do
	    for ((j=0;j<NUMBER_OF_COLUMNS;j++)) do
	    	index=$(getIndex $i $j)
	        if [ ${matrix[$index]} == 0 ]
	        then
	        	flag=0
	        	break
	        fi
	    done
	    if [ $flag -eq 0 ]
        then
        	break
        fi
	done
	echo $flag
}

checkWin(){
	if [ $(checkRows) -eq 1 ]
	then
		echo 1
	elif [ $(checkColumns) -eq 1 ]
	then
		echo 1 
	elif [ $(checkMainDiagonal) -eq 1 ]
	then
		echo 1
	elif [ $(checkOffDiagonal) -eq 1 ]
	then
		echo 1
	else
		echo 0
	fi
}

checkBoard(){
	if [ $(checkWin) -eq 1 ]
	then
		echo $WIN
		echo "Win"
	elif [ $(checkTie) -eq 1 ]
	then
		echo $TIE
		echo "Tie"
	else
		echo $NEXT_TURN
		echo "Next turn"
	fi
}
echo "UC6 implemented in subsequent use cases"


