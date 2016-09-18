#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
LOCAL_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
DIR_GRAMMAR="$LOCAL_DIR/scripts" 
DIR_CLARA="$LOCAL_DIR/clara" 

DIR_BIN="$HOME/voxforge/bin" 
DIR_HTK="$DIR_BIN/htk" 
DIR_JULIUS="$DIR_BIN/julius-4.3.1" 

DIR_TUTORIAL="$HOME/voxforge/tutorial" 
DIR_TRAIN="$HOME/voxforge/train" 
DIR_WAV="$HOME/voxforge/wav" 
enterDir()
{ 
	cd "$1" || exit
	echo "-----Enter folder $1-----"
}

enterDir "$DIR_TUTORIAL"
echo "----------Generating dict files----------"
julia ../bin/mkdfa.jl clara
echo "----------Done dict----------"

echo "----------Generating word lists from prompt file----------"
julia ../bin/prompts2wlist.jl prompts.txt wlist
echo "----------Done word lists----------"

echo "----------Generating monophones 0 and 1----------"
python ../bin/dict2phone.py 
echo "----------Done monophones 0 and 1----------"

echo "----------Generating MLF (Master Label File) from prompt file----------"
julia ../bin/prompts2mlf.jl prompts.txt words.mlf
echo "----------Done MLF----------"

echo "----------Generating Word Level Transcriptions to Phone Level Transcriptions----------"
HLEd -A -D -T 1 -l '*' -d dict -i phones0.mlf mkphones0.led words.mlf 
HLEd -A -D -T 1 -l '*' -d dict -i phones1.mlf mkphones1.led words.mlf 
echo "----------Done HLed----------"
