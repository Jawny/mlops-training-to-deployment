
# End to End Workflow with Base Command Platform and Fleet Command

## Step 1. Create a Workspace
Start off by running 
```
./1-create-a-workspace.sh
```
This creates a workspace on NGC and spins up a cpu job that will run "git clone" with the specified git repo. 

## Step 2. Upload Dataset
Next up, run 
```
./2-upload-dataset.sh
```
This creates a training and validation dataset and uploads the files accordingly to NGC. In this example, we won't have a training dataset as
we'll be using Tensorflow to pull the CIFAR-10 dataset directly.
## Step 3. Start Training job
To kick off our training job run
```
./3-start-training-job.sh
```
This will spin up a job using NVIDIA's DGX GPU with a Tensorflow image. It will also mount the workspace and datasets we created earlier
to be used for training and validation. 
## Step 4. Upload to the Private Registry
Once we've validated that the model is accurate run
```
./4-upload-to-ngc.sh
```
to upload the model to the private registry. If a model already exists the script will create a new version, but if the model
doesn't exist it will create a new model and upload it as v1.
## Step 5. Setup Fleet Command
Run the following to create a location and system on Fleet Command.
```
./5-setup-fleetcommand
```
Once this is setup, login to your system and connect it with the code generated from Fleet Command. 

It will look like this:
![fleet command screenshot](https://i.imgur.com/OJKYzha.png)
