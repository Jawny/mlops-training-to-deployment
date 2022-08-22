#!/bin/bash
# Enter the name of the training job
job_name="launchpad_training_job"
# Save the training job name to a log file for later reference
echo ${job_name} > job_name.log
# Enter commands to run on job start. ie. cd /mnt/data; python3 training.py
command_line="cd /mnt/workspace/training; python3 launchpad.py"
# Grab training dataset id 
training_dataset_id=`grep 'Dataset ID:' training_dataset_output.log | awk '{print $3}'`
# Grab training workspace id
training_workspace_id=`grep 'Successfully created workspace with ID:' training_workspace_output.log | awk '{print $6}' | tr -d "'"`
# Grab validation dataset id
validation_dataset_id=`grep 'Dataset ID:' validation_dataset_output.log | awk '{print $3}'`

# Start a job with a tensorflow image
ngc batch run --name ${job_name} --instance dgx1v.32g.4.norm --image "nvidia/tensorflow:22.07-tf2-py3" --workspace ${training_workspace_id}:/mnt/workspace/training:RW --datasetid ${training_dataset_id}:/mnt/data/training --datasetid ${validation_dataset_id}:/mnt/data/validation --commandline "${command_line}" --result /results 
