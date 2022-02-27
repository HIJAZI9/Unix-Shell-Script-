#!/bin/bash

marks=0
rm -rf all stat

#Checking number of arguments passed to script , if number of argument is not equal to 1 the script will end
if [ $# -ne 1 ]
then
 echo "Please provide one argumnet("all", "stat","plag","t[0-9]{5}") to script"
 exit 1;
fi

ARG=$1

# Using or operator in if statement checking the valid 4 arguments
if [ ${ARG} == "all" ] || [ ${ARG} == "stat" ] || [ ${ARG} == "plag" ] || [[ ${ARG} =~ ^t[0-9]{5}$ ]]
then
   :
else
# if correct arguments are not passed  script will exit
  echo "Please provide correct argument"
  exit 2;
fi

#Creating function for marking
marking() {
  ARG=$1
  FILE=data/${ARG}
  # Checking if file exist or not
  if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist"
    exit 3;
  fi
  # checking first two characters of the first line
  shebang=`cat $FILE | head -1 | cut -c 1-2`
  if [ $shebang == "#!" ]
  then 
    marks=$((marks + 1))
    echo "First line of the file $FILE begins with shebang $shebang" 
  else
    echo "First line of the file $FILE does not begins with shebang $shebang"
  fi
 
  #Finding the percentage of lines with comment
  TLines=`cat ${FILE} | wc -l`
  CLines=`cat ${FILE} | grep -o "#" | grep -v ^#! | wc -l `
 
  Percentage=`echo $(( CLines*100/TLines ))`   
  echo "$Percentage% lines in $FILE are comments"
  if [ $Percentage -ge 10 ]
  then
    marks=$((marks + 1))
  fi
  
  # Finding number of exit statement which are not commented
  exit_count=`grep exit ${FILE} | grep -v ^# | wc -l`
  echo "There are $exit_count exit statement in file ${FILE}"
  if [ $exit_count -ge 1 ]
  then
     marks=$((marks + 1))
  fi

  #Running script  without parameter and checking if return value is 0
  chmod +x ${FILE} 
 ./${FILE} &> /dev/null; status=$?;
  if [ $status -ge 1 ]
  then
     echo "Return value is not zero"
     marks=$((marks + 1))
  else
     echo "Return value is  zero"
     
  fi

  #Running the script with count parameter and checking the number of rows
  cd data
  bib_count=`cat bib.csv | wc -l`
  ./${ARG} count &> tmp
  script_count=`cat tmp |  grep -Eo "[0-9]{3}"`
  if [ ! -z $script_count ] ; then
     echo "Number of lines in bib.csv is $script_count"
     if [ $bib_count == $script_count ]
     then
       marks=$((marks + 1))
     fi
  else
     echo "Number of lines in bib.csv can not be found"   
  fi
  # Andere Methode um file mit cout Parameter auszuführen.
  #Call the file with the parameter "count", stdout should be the number of lines in bib.csv
            
            #Output=0
            #Output=$(./$FILE count )     
            #Output=$(echo "$Output" | grep -o -E "[0-9]{3}") 
  cd ..
echo "The file $ARG got $marks points, $marks correct missions"
  echo "$ARG:$marks" >> all
chmod -x ${FILE}
}  #marking function end here




if [[ ${ARG} =~ ^t[0-9]{5}$ ]]
then
  marking $ARG
elif [[ ${ARG} == all ]]
then
  #reading all the files from directory data
  for files in `ls data/t*[0-9]` 
  do 
     marks=0
     script=`echo $files | cut -d "/" -f2` 
     #calling the marking function for all the 89 files present in data directory
     marking $script
     echo "********************************"
  done
     echo "Following files does not achieve the full number"
     # checking the marks against each fiiles and printing the once who have not got 5 marks
     cat all | awk -F ":" '$2 < 5 {print $1}' 
elif [[ ${ARG} == stat ]]
then
   for files in `ls data/t*[0-9]`
   do
     #finding the size of the individual documnets
     size=`ls -lart $files | cut -d " " -f5`
     script=`echo $files |cut -d "/" -f2`
     echo "$script $size" >> stat
   done
     echo "Name and size of smallest documnet"
     cat stat | sort -t " " -nk 2 | head -1  # finding smallest files
     echo "Name and size of largest document"
     cat stat | sort -t " " -nk 2 | tail -1   #finding largest files
     sum=`cat stat | awk -F " " '{sum+=$2;} END{print sum;}'`  #sum of all the all documnet sizes
     n=`cat stat| wc -l`
     mean=`echo $(( sum/n ))`  #calculating mean 
     echo "Airthmetic mean of all document sizes is $mean"
#Argument plag um alle Pruflinge paarweise miteinander verglichen ¨werden
elif [[ ${ARG} == plag ]]
then
 files_array=($(ls data/t*[0-9]))
    for ((i=0; i<${#files_array[@]}-1; i++))
    do
        for ((j=i+1; j<${#files_array[@]}; j++))
        do
            line_count=$(diff -s ${files_array[$i]} ${files_array[$j]} | wc -l)
#This is the same command I used above where i also used the "wc -l" command. Using this
# command, we will print the ouptut on the screen that says "Files txxxxx and txxxxx are identical
            if [ $line_count -eq 1 ]
            then
                diff -s ${files_array[$i]} ${files_array[$j]}
            fi
        done
    done
fi

#removing temporary files
cd ..
rm -rf all tmp data/tmp
