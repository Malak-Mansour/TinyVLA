#!/bin/bash
#SBATCH --job-name=train_tinyvla_ECoT_libero
#SBATCH --output=logs_process_chkpts/debug_%j.out
#SBATCH --error=logs_process_chkpts/debug_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --gres=gpu:1
#SBATCH --partition=cscc-gpu-p
#SBATCH --qos=cscc-gpu-qos
#SBATCH --time=12:00:00
#SBATCH --exclude=gpu-05

# This scripts is used to process the trained weights and generates a smaller and compact weights
LLM_MODEL_SIZE=410M


# path to trained TinyVLA weights
# source_dir="/path/to/trained/VLA/weights"
source_dir="/l/users/malak.mansour/Datasets/TinyVLA"

# new path to save weights
# target_dir="/path/to/save/processed/VLA/weights"
target_dir="/l/users/malak.mansour/Datasets/TinyVLA/processed"


mkdir -p $target_dir

exclude_pattern="global_step*"

echo "copying checkpoints from $source_dir to $target_dir"
rsync -av --exclude="$exclude_pattern" --exclude="$exclude_pattern/**" "$source_dir/" "$target_dir/"

echo 'tranfer checkpoints to non_lora_trainables.bin'
for dir in "$source_dir"/*/ ; do

    if [[ "$(basename "$dir")" == *"checkpoint"* ]]; then
      if ! find "$dir" -mindepth 1 -type f -name "non_lora_trainables.bin" | grep -q .; then
        cd "$dir" || exit
        python ./zero_to_fp32.py ./ ${target_dir}/$(basename "$dir")/non_lora_trainables.bin
        # cp $OUTPUT/non_lora_trainables.bin $dir
        fi
    fi
done

cd "/data/junjiewen/droid_results/checkpoint_all" || exit

