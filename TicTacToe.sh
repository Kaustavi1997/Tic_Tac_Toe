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
	elif [ $(checkTie) -eq 1 ]
	then
		echo $TIE
	else
		echo $NEXT_TURN
	fi
}
playForWin(){
	local flag=0
	for ((i=0;i<NUMBER_OF_ROWS;i++)) do
	    for ((j=0;j<NUMBER_OF_COLUMNS;j++)) do
	    	index=$(getIndex $i $j)
	    	if [ ${matrix[$index]} == 0 ]
	    	then
	    		matrix[$index]=$computerSymbol
	    		if [ $(checkWin) -ne 1 ]
	    		then
	    			matrix[$index]=0
	    		else
	    			flag=1
	    			break
	    		fi
	    	fi
	    done
	    if [ $flag -eq 1 ]
    	then
    		break
    	fi
	done
	echo $flag
}
playForBlock(){
	local flag=0
	for ((i=0;i<NUMBER_OF_ROWS;i++)) do
	    for ((j=0;j<NUMBER_OF_COLUMNS;j++)) do
	    	index=$(getIndex $i $j)
	    	if [ ${matrix[$index]} == 0 ]
	    	then
	    		matrix[$index]=$playerSymbol
	    		if [ $(checkWin) -ne 1 ]
	    		then
	    			matrix[$index]=0
	    		else
	    			matrix[$index]=$computerSymbol
	    			flag=1
	    			break
	    		fi
	    	fi
	    done
	    if [ $flag -eq 1 ]
    	then
    		break
    	fi
	done
	echo $flag
}

takeCorners(){
	if [ ${matrix[$(getIndex 0 0)]} == 0 ]
	then
		matrix[$(getIndex 0 0)]=$computerSymbol
		echo 1
	elif [ ${matrix[$(getIndex 0 $(($NUMBER_OF_COLUMNS-1)))]} == 0 ]
	then
		matrix[$(getIndex 0 $(($NUMBER_OF_COLUMNS-1)))]=$computerSymbol
		echo 1
	elif [ ${matrix[$(getIndex $(($NUMBER_OF_COLUMNS-1)) 0)]} == 0 ]
	then
		matrix[$(getIndex $(($NUMBER_OF_COLUMNS-1)) 0)]=$computerSymbol
		echo 1
	elif [ ${matrix[$(getIndex $(($NUMBER_OF_COLUMNS-1)) $(($NUMBER_OF_COLUMNS-1)))]} == 0 ]
	then
		matrix[$(getIndex $(($NUMBER_OF_COLUMNS-1)) $(($NUMBER_OF_COLUMNS-1)))]=$computerSymbol
		echo 1
	else
		echo 0
	fi
}

takeCentre(){
	local centre=$(($NUMBER_OF_COLUMNS/2))
	local intCentre=${centre%.*}
	if [ ${matrix[$(getIndex $intCentre $intCentre)]} == 0 ]
	then
		matrix[$(getIndex $intCentre $intCentre)]=$computerSymbol
		echo 1
	else
		echo 0
	fi
}
takeSides(){
	local mid=$(($NUMBER_OF_COLUMNS/2))
	local intMid=${mid%.*}
	if [ ${matrix[$(getIndex 0 $intMid)]} == 0 ]
	then
		matrix[$(getIndex 0 $intMid)]=$computerSymbol
	elif [ ${matrix[$(getIndex $(($NUMBER_OF_COLUMNS-1)) $intMid )]} == 0 ]
	then
		matrix[$(getIndex $(($NUMBER_OF_COLUMNS-1)) $intMid )]=$computerSymbol
	elif [ ${matrix[$(getIndex $intMid $(($NUMBER_OF_COLUMNS-1)))]} == 0 ]
	then
		matrix[$(getIndex $intMid $(($NUMBER_OF_COLUMNS-1)))]=$computerSymbol
	elif [ ${matrix[$(getIndex $intMid 0)]} == 0 ]
	then
		matrix[$(getIndex $intMid 0)]=$computerSymbol
	fi
}

playerPlays(){
	local valid=0
	while [ $valid -ne 1 ]
	do
		read -p "Enter Row:" playerRow;
		read -p "Enter Column:" playerColumn;
		playerIndex=$(getIndex $(($playerRow-1)) $(($playerColumn-1)))
		if [ $playerIndex -lt $(($NUMBER_OF_COLUMNS*$NUMBER_OF_COLUMNS)) ]
		then
			valueAtPosition=${matrix[$playerIndex]}	
			if [ $valueAtPosition == 0 ]
			then
				matrix[$playerIndex]=$playerSymbol
				valid=1
			else
				echo "Invalid! Enter again!"
			fi
		else
			echo "Invalid! Enter again!"
		fi
	done

}

computerPlays(){
	if [ $(playForWin) -eq 1 ]
	then
		echo "Win"
		playForWin
	elif [ $(playForBlock) -eq 1 ]
	then
		echo "Blocked"
		playForBlock
	elif [ $(takeCorners) -eq 1 ]
	then
		echo "Corner taken"
		takeCorners
	elif [ $(takeCentre) -eq 1 ]
	then
		echo "Centre taken"
		takeCentre
	else
		echo "Side taken"
		takeSides
	fi
}

switchPlayer(){
	local computer=$1
	local player=$((1-$computer))
	if [ $player -eq 1 ]
	then
		playerPlays
		showBoard
	else
		computerPlays
		showBoard
	fi
}

playGame(){
	resetBoard
	assignSymbol
	getToss
	showBoard
	if [ $toss -eq 0 ]
	then
		switchPlayer 0
	else
		switchPlayer 1
	fi

	while [ $1=1 ]
	do  
		switchPlayer $((1-$toss))
		toss=$((1-$toss))

		result=$(checkBoard)
		# echo "result=$result"
		if [ $result -eq $NEXT_TURN ]
		then
			echo "Next turn"
		elif [ $result -eq $WIN ]
		then
			if [ $toss -eq 0 ]
			then
				echo "Player wins!"
			else
				echo "Computer wins!"
			fi
			break
		else
			echo "Tie!"
			break
		fi
	done
}
playGame


