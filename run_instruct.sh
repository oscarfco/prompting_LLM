#!/usr/bin/zsh
session_id="${1:-11}"
cuda="${2:-0}"
port="${3:-5005}"
start_idx="${4:-0}"
end_idx="${5:--1}"

export SESSION_ID=$session_id
export CUDA_VISIBLE_DEVICES=$cuda
export DEVICE_ID=0
export FLASK_PORT=$port
export URL="127.0.0.1"
# export MODEL_CHECKPOINT="/home/aswag/code/Decentralized_FM_alpha/models/instruct-ni-cot/checkpoint_2400"
# export NSTAGES=4
# export N_LAYERS=7
# export SAVE_PATH="ni-cot-checkpoint_2400"

echo "Session ID: $SESSION_ID"
echo "CUDA: $CUDA_VISIBLE_DEVICES"
echo "Device ID: $DEVICE_ID"
echo "Flask Port: $FLASK_PORT"
echo "URL: $URL"
echo "Start: $start_idx"
echo "End: $end_idx"

# for MODEL_NAME in EleutherAI/gpt-j-6B facebook/opt-6.7b bigscience/bloom-6b3 EleutherAI/gpt-neo-2.7B EleutherAI/gpt-neo-1.3B EleutherAI/gpt-neo-125M; do
# for MODEL_NAME in bigscience/bloom-350m bigscience/bloom-1b7 bigscience/bloom-3b bigscience/bloom-6b3; do
for MODEL_NAME in EleutherAI/gpt-j-6B; do
    tmux kill-session -t $SESSION_ID
    tmux new -d -t  $SESSION_ID
    tmux send-keys -t $SESSION_ID "conda activate ahojel" ENTER
    tmux send-keys -t $SESSION_ID "export FLASK_PORT=${FLASK_PORT}" ENTER
    tmux send-keys -t $SESSION_ID "export MANIFEST_SESSION_HOME=/home/ahojel/ama_prompting/manifest" ENTER
    tmux send-keys -t $SESSION_ID "python3 manifest/manifest/api/app.py --port ${FLASK_PORT} --model_type huggingface --model_name ${MODEL_NAME} --cache_dir /home/ahojel/transformers_cache --device ${DEVICE_ID}" ENTER

    # --checkpoint_path ${MODEL_CHECKPOINT} --n_stages ${NSTAGES} --n_layer_per_stage ${N_LAYERS} --cache_dir /home/aswag/code/transformers_cache --device ${DEVICE_ID}

    # python3 /home/aswag/code/ama_prompting/wait_model_load.py --connection_str http://${URL}:${FLASK_PORT}

    # for f in ANLIR1_final.py; do
	# python3 /home/aswag/code/ama_prompting/tasks/$f --run_zeroshot 1 --run_fewshot 0 --run_decomp 0 --num_boost 3 --k_shot 10 --output_metrics_file ../ama_logs/${SAVE_PATH}/metrics.json --cache_connection ../ama_logs/${SAVE_PATH}/manifest_cache.sqlite --save_dir ../ama_logs/${SAVE_PATH}/ama_final_runs --client_connection http://${URL}:${FLASK_PORT}        
    # done;
    # for f in ANLIR1_final.py ANLIR2_final.py ANLIR3_final.py Amazon_final.py BoolQ_final.py CB_final.py COPA_final.py DBPedia_final.py drop_final.py MR_final.py MultiRC_final.py News20_final.py SST2_final.py WIC_final.py WSC_final.py boosting_RTE.py; do
    #     echo "Running /home/ahojel/ama_prompting/tasks/${f}"
    #     python3 /home/ahojel/ama_prompting/tasks/$f --client_connection http://${URL}:${FLASK_PORT} --run_zeroshot 1 --run_fewshot 1 --run_decomp 1 --num_boost 3 --boost_train_examples 1000 --k_shot 3
    # done;
done;
