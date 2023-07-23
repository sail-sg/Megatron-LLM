#! /bin/bash

# assert correct usage
if [[ $# -ne 4 ]]; then
	echo "Usage: $0 <llama/falcon> <7,13,30,40,65> <tp> <pp>"
	exit 1
fi


# extract variables from command line
MODEL=$1
SIZE=$2
TENSOR_PARALLELISM=$3
PIPELINE_PARALLELISM=$4


# model-specific parameters
if [[ $MODEL = falcon ]]; then
	TRUE_VOCAB_SIZE=65024
elif [[ $MODEL = llama ]] || [[ $MODEL = llama2 ]]; then
	TRUE_VOCAB_SIZE=32000
fi


# finally call the script
python tools/checkpoint_util.py \
       --target_tensor_parallel_size $TENSOR_PARALLELISM \
       --target_pipeline_parallel_size $PIPELINE_PARALLELISM \
       --load_dir /pure-mlo-scratch/alhernan/megatron-data/checkpoints/${MODEL}-${SIZE}b/ \
       --save_dir /pure-mlo-scratch/alhernan/megatron-data/checkpoints/${MODEL}-${SIZE}b-tp$TENSOR_PARALLELISM-pp$PIPELINE_PARALLELISM/ \
       --model_type $MODEL \
       --true_vocab_size $TRUE_VOCAB_SIZE
