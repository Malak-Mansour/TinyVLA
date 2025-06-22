#!/bin/bash

# pick_yellow_cup_and_put_it_in_pot.hdf5
# ├── episode_1/
# │   ├── actions/ nx7
# │   ├── teleop_actions/ nx7
# │   └── obs/
# │       ├── agentview_rgb nx224x224x3
# │       ├── eye_in_hand_rgb nx224x224x3
# │       ├── ee_states nx6
# │       ├── gripper_states nx1
# │       └── joint_positions nx6
# ├── episode_10/
# ├── episode_12/
# └── ...


ACTION_HEAD=droid_diffusion # specify action policy head type
# define OUTPUT path

OUTPUT=/l/users/malak.mansour/TinyVLA

if [ -d "$OUTPUT" ]; then
   echo 'output exists'
else
   echo '!!output not exists!!'
   mkdir -p $OUTPUT
fi
# backup the train scripts
cp ./scripts/train.sh $OUTPUT

# detailed usage of each parameter can be found in train_tinyvla.py

# in terminal do:
  # pip install wandb
  # wandb login
    # paste API key from wandb account: 10f09f627a9b590a6b8ed117af68260ffb2fb0e3
# export WANDB_PROJECT="TinyVLA"
# export WANDB_NAME="tinyvla-run-$(date +%Y%m%d-%H%M%S)"
# export WANDB_DIR=$OUTPUT/log
# export WANDB_MODE=offline  # or "offline" if no internet


deepspeed --master_port 29600 --num_gpus=1 --num_nodes=1 ./train_tinyvla.py \
  --deepspeed /home/malak.mansour/Downloads/ICL/TinyVLA/llava-pythia/scripts/zero2.json \
  --lora_enable True \
  --lora_module 'vit llm' \
  --load_pretrain False \
  --pretrain_image_size 320 \
  --lora_r 64 \
  --lora_alpha 256 \
  --non_lora_lr 2e-5 \
  --task_name "do_manual" \
  --model_name_or_path lesjie/Llava-Pythia-400M \
  --version v0 \
  --tune_mm_mlp_adapter True \
  --freeze_vision_tower True \
  --freeze_backbone True \
  --mm_use_im_start_end False \
  --mm_use_im_patch_token False \
  --image_aspect_ratio pad \
  --group_by_modality_length False \
  --bf16 False \
  --output_dir $OUTPUT \
  --max_steps 10000 \
  --per_device_train_batch_size 32 \
  --gradient_accumulation_steps 1 \
  --save_strategy "steps" \
  --save_steps 1000 \
  --save_total_limit 50 \
  --learning_rate 2e-4 \
  --weight_decay 0. \
  --warmup_ratio 0.005 \
  --lr_scheduler_type "cosine" \
  --logging_steps 10 \
  --tf32 False \
  --model_max_length 2048 \
  --gradient_checkpointing True \
  --dataloader_num_workers 8 \
  --lazy_preprocess True \
  --action_head_type $ACTION_HEAD \
  --use_state True \
  --concat "token_cat" \
  --window_size 6 \
  --report_to none \
  --logging_dir $OUTPUT/log

for dir in "$OUTPUT"/*/ ; do
    # 检查文件夹名称是否包含'checkpoint'
    if [[ "$(basename "$dir")" == *"checkpoint"* ]]; then
        cp llava-pythia/preprocessor_config.json $dir
    fi
done

  # --report_to tensorboard \
  # --deepspeed scripts/zero2.json \
  # --use_state True \
  # --window_size 6 \

  # --report_to wandb \