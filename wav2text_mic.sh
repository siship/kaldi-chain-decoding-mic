#!/bin/bash

# Author: Sishir Kalita
# Run this code, provide the folder name. 
# Press enter and speak for the specified duration
# Decode text will be shown in the terminal
# how to use: ./wav2text_mic.sh

# Date: September 14, 2020

dataFolder=audio

nsec=5

read -p "Enter date and time of recordings (if Sep 14, 2020 --> 300914): " folder_name
dir_name=$dataFolder/$folder_name

if [ ! -d $dir_name ]; then 
  echo "creating a folder" "$dir_name"
  mkdir $dir_name
fi

counter=0
onee=1

while [ $counter -lt 10 ]     
do  
  file_name=$(date +%s)

  path_name=$dataFolder/$folder_name/$file_name".wav"

  read -n 1 -r -s -p $'Press enter and speak \n'

  rec -r 8000 -b 16 -c 1 $path_name trim 0 $nsec

  ./kaldi_online_decod.sh $path_name

  counter=$(expr "$counter" + 1)

done
echo "Thanks"


