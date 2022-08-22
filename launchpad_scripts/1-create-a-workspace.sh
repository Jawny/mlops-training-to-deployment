#!/bin/bash
# Enter any workspace name for your training code.
training_workspace_name="launchpad_training_workspace"
# Enter url of git link with your training code, i.e: https://github.com/NVIDIA/DeepLearningExamples.git
training_git_url="https://github.com/Jawny/mlops-training-to-deployment.git"
# Create a workspace and save the stdout in a log file
ngc workspace create --name "${training_workspace_name}" | tee training_workspace_output.log
# Grab the workspace id from the log file and create
# a job that runs git clone on the git_url
training_job_id=`grep 'Successfully created workspace with ID:' workspace_output.log | awk '{print $5}' | tr -d "'"`
ngc batch run --name "${training_workspace_name}" --preempt RUNONCE --min-timeslice 0s --total-runtime 0s --instance cpu.x86.tiny --commandline "cd /mnt/workspace; git clone ${training_git_url}" --result /results --image "nvidian/pytorch:22.06-py3" --workspace $training_job_id:/mnt/workspace:RW
