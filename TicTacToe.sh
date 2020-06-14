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

createBoard(){
	for ((i=0;i<NUMBER_OF_ROWS;i++)) do
	    for ((j=0;j<NUMBER_OF_COLUMNS;j++)) do
	    	matrix+=(0)
	    done
	done
}

getIndex(){
	local i=$1
	local j=$2
	local linearIndex=$(($i*$NUMBER_OF_COLUMNS+$j))
	echo $linearIndex
}

resetBoard(){
	for ((i=0;i<NUMBER_OF_ROWS;i++)) do
	    for ((j=0;j<NUMBER_OF_COLUMNS;j++)) do
	    	matrix[$(getIndex $i $j)]=0
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

ifConditionForFlag(){
	local flag=$1
	if [ $flag -eq 0 ]
	then
		echo 0
	else
		echo 1
	fi
}

checkRows(){
	local flag=0
	local rowFlag
	local firstElement=0
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
	ifConditionForFlag $flag

	
}

checkColumns(){
	local flag=0
	local firstElement=0
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
	ifConditionForFlag $flag
}

checkDiagonals(){
	local flagMain=1
	local flagOff=1
	local firstElementMainDiagonal=${matrix[$(getIndex 0 0)]}
	local firstElementOffDiagonal=${matrix[$(getIndex 0 $(($NUMBER_OF_ROWS-1)))]}

	if [ $firstElementMainDiagonal == 0 ]
	then
		flagMain=0
	fi

	if [ $firstElementOffDiagonal == 0 ]
	then
		flagOff=0
	fi

	for ((i=1;i<NUMBER_OF_ROWS;i++)) do
		if [ $flagMain == 1 ]
		then
	    	if [ $firstElementMainDiagonal != ${matrix[$(getIndex $i $i)]} ]
	    	then 
	    		flagMain=0
	    	fi
	    fi

	    if [ $flagOff == 1 ]
	    then
	    	if [ $firstElementOffDiagonal != ${matrix[$(getIndex $i $(($NUMBER_OF_ROWS-1-$i)))]} ]
	    	then 
	    		flagOff=0
	    	fi
	    fi
	done

	if [ $flagMain -eq 1 -o $flagOff -eq 1 ]
	then
		echo 1
	else
		echo 0
	fi
}


ifConditionForFlagBreak(){
	local flag=$1
	if [ $flag -eq 1 ]
    then
       break
    fi
}

checkTie(){
	local flag=0
	local index=0
	for ((i=0;i<NUMBER_OF_ROWS;i++)) do
	    for ((j=0;j<NUMBER_OF_COLUMNS;j++)) do
	    	index=$(getIndex $i $j)
	        if [ ${matrix[$index]} == 0 ]
	        then
	        	flag=1
	        	break
	        fi
	    done
	    ifConditionForFlagBreak $flag
	done
	echo $((1-$flag))
}

checkWin(){
	if [ $(checkRows) -eq 1 ]
	then
		echo 1
	elif [ $(checkColumns) -eq 1 ]
	then
		echo 1 
	elif [ $(checkDiagonals) -eq 1 ]
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


playForWinOrBlock(){
	local winOrBlock=$1
	local flag=0
	local index=0
	for ((i=0;i<NUMBER_OF_ROWS;i++)) do
	    for ((j=0;j<NUMBER_OF_COLUMNS;j++)) do
	    	index=$(getIndex $i $j)

	    	if [ $winOrBlock -eq 1 ]
	    	then
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
		    else
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
		    fi

	    done
	    ifConditionForFlagBreak $flag
	done
	echo $flag
}

takeCorners(){
	local extremeIndices=( 0 $(($NUMBER_OF_COLUMNS-1)) )
	local flag=0
	for ((i=0;i<2;i++)) do
		for ((j=0;j<2;j++)) do
			if [ ${matrix[$(getIndex ${extremeIndices[$i]} ${extremeIndices[$j]} )]} == 0 ]
			then
				matrix[$(getIndex ${extremeIndices[$i]} ${extremeIndices[$j]} )]=$computerSymbol
				flag=1
				break
			fi
		done 
		ifConditionForFlagBreak $flag
	done
	ifConditionForFlag $flag
}


getMidPosition(){
	local mid=$(($NUMBER_OF_COLUMNS/2))
	local intMid=${mid%.*}
	echo $intMid
}

takeCentre(){
	local centre=$(getMidPosition)

	if [ ${matrix[$(getIndex $centre $centre)]} == 0 ]
	then
		matrix[$(getIndex $centre $centre)]=$computerSymbol
		echo 1
	else
		echo 0
	fi
}

takeSides(){
	local midPosition=$(getMidPosition)
	local extremeIndices=( 0 $(($NUMBER_OF_COLUMNS-1)) )
	
	for ((i=0;i<2;i++)) do
		if [ ${matrix[$(getIndex ${extremeIndices[$i]} $midPosition )]} == 0 ]
		then
			matrix[$(getIndex ${extremeIndices[$i]} $midPosition )]=$computerSymbol
			break
		fi 
	done

	for ((i=0;i<2;i++)) do
		if [ ${matrix[$(getIndex $midPosition ${extremeIndices[$i]} )]} == 0 ]
		then
			matrix[$(getIndex $midPosition ${extremeIndices[$i]} )]=$computerSymbol
			break
		fi 
	done
}

playerPlays(){
	local valid=0
	local playerIndex=0
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
	if [ $(playForWinOrBlock 1) -eq 1 ]
	then
		echo "Win"
		playForWinOrBlock 1
	elif [ $(playForWinOrBlock 0) -eq 1 ]
	then
		echo "Blocked"
		playForWinOrBlock 0
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
	local playerDecision="y"
	while [ $playerDecision == "y" ]
	do
		resetBoard
		assignSymbol
		getToss
		showBoard
		local result=0
		if [ $toss -eq 0 ]
		then
			switchPlayer $toss
		else
			switchPlayer $toss
		fi

		while [ $1=1 ]
		do  
			switchPlayer $((1-$toss))
			toss=$((1-$toss))

			result=$(checkBoard)
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
		read -p "Do you want to play again?(y/n):" playerDecision;
	done
}
createBoard
playGame
	

