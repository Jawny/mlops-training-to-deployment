#!/bin/bash
# Grab the job id from the training job 
job_id=`grep 'Id:' ./training_job_output.log | awk '{print $2}' |tr -d "'"`
# Enter name of model on NGC
model_name="launchpad_model"
# Download the model from the training job results
ngc result download ${job_id}
# Source path of model will be the job id when downloaded
source_path="./${job_id}"
# Check the current version of the model if it exists
curr_version=`ngc registry model info egxdefault/${model_name} | grep "Latest Version ID:" | awk '{print $4}' | tr -dc '0-9'`
# Try to upload the model as a new version, but if it errors out save the error to a output file
ngc registry model upload-version egxdefault/${model_name}:v$((++curr_version)) --source ${source_path} > out 2>ngc-upload.log
upload_result=`grep "Error:" ngc-upload.log`
# If there is an error with the upload, upload again as v1 but this time create the model first
if grep -R "Error:" ngc-upload.log
then
    ngc registry model create egxdefault/${model_name} --application joliao-demo-app --framework pytorch --format ProtoText --precision FP16 --short-desc "demo"
    ngc registry model upload-version egxdefault/${model_name}:v1 --source ${source_path}
else
    echo "pass"
fi
