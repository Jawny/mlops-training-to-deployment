#!/bin/bash
# Create a validation job name by appending -validation to the training job name
job_name=`head -n 1 job_name.log`-validation
# Grab validation dataset id
dataset_id=`grep 'Dataset ID:' dataset_output.log | awk '{print $3}'`
# Grab workspace id with validation code
workspace_id=`grep 'Successfully created workspace with ID:' validation_workspace_output.log | awk '{print $6}' | tr -d "'"`
# Enter commands to run on job start. ie. cd /mnt/data; python3 validation.py
command_line="cd /mnt/data; python3 launchpad-validation.py"
# Grab the job id from the training job 
training_job_id=`grep 'Id:' ./training_job_output.log | awk '{print $2}' |tr -d "'"`
# Download the model from the training job results
ngc result download ${job_id}
# Source path of model will be the job id when downloaded
model_source_path="./${job_id}"
# Upload the newly trained model to a dataset
ngc dataset upload --source ${model_source_path} ${validation_dataset_name} | tee model_dataset_output.log
ngc batch run --name ${job_name} --instance dgxa100.40g.1.norm --image "nvidia/tensorflow:22.07-tf2-py3" --datasetid ${dataset_id}:/mnt/data --workspace ${workspace_id}:/mnt/workspace:RW --commandline ${command_line} --result /results | tee job_output.log
