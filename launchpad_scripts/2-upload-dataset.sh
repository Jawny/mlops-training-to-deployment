#!/bin/bash
# Enter the name of the dataset
training_dataset_name="launchpad_training_dataset"
# Enter the path to the dataset
training_source_path="../validation_dataset"
# Upload dataset to NGC and save the output to a output log 
ngc dataset upload --source ${training_source_path} ${training_dataset_name} | tee training_dataset_output.log

# Enter the name of the dataset
validation_dataset_name="launchpad_validation_dataset"
# Enter the path to the dataset
validation_source_path="../validation_dataset"
# Upload dataset to NGC and save the output to a output log 
ngc dataset upload --source ${validation_source_path} ${validation_dataset_name} | tee validation_dataset_output.log