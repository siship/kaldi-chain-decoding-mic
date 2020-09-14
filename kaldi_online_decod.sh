#!/bin/bash

# Author: Sishir Kalita

# Decoding of kaldi chain model.
# Provide the Kaldi chain model in the respective path
# how to use: ./kaldi_online_decod.sh data/temp.wav
# decoded text will be shown in the terminal

# Date: September 14, 2020

. ./cmd.sh
[ -f ./path.sh ] && . ./path.sh; # source the path.

#get input file 
wavepath=$1
ts=$(date +%s%N)
start_time=`date +%s`

#=================================================
# 		Directories setting
#=================================================
# Model
dir=chain/tdnn1a_sp_online
# Trained chain model
model=$dir/final.mdl
# Online config file
online_config=$dir/conf/online.conf
word_table=chain/tree_a_sp/graph_bigram/words.txt
graph_model=chain/tree_a_sp/graph_bigram/HCLG.fst

cmd=run.pl

# log files
logFiles=logFiles

# Data store
dataFolder=data_online

rm -r $dataFolder/temp.wav

sox $wavepath -r 8000 -t wav -b 16 $dataFolder/temp.wav

$cmd $logFiles/decode.log online2-wav-nnet3-latgen-faster \
  --online=false \
  --do-endpointing=false \
  --frame-subsampling-factor=3 \
  --config=$online_config \
  --max-active=7000 \
  --beam=15.0 \
  --lattice-beam=8.0 \
  --acoustic-scale=1.0 \
  --word-symbol-table=$word_table \
  $model \
  $graph_model ark:$dataFolder/spk2utt "ark,s,cs:wav-copy scp,p:$dataFolder/wav.scp ark:- |" "ark:| lattice-best-path --acoustic-scale=1.0 ark:- ark,t:- | utils/int2sym.pl -f 2- $word_table > $dataFolder/output.txt"  


end_time=`date +%s`

echo  "Hi, you said...."
while read line
do 
textt="$(cut -d ' ' -f2- <<<$line)"
echo $textt
echo -e $wavepath "$textt \t \t $((($(date +%s%N) - $ts)/1000000)) ms"  >> wavepath_text_time
done < $dataFolder/output.txt

exit 0;
