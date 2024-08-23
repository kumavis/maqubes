#!/bin/bash
set -euo pipefail
# set -x
IFS=$'\n\t'


# command: "create" makes a new vm
create() {
  project_name=$2
  project_identity_file="maqubes_${project_name}_rsa"
  echo "Creating a new vm with the name: ${project_name}"
  # create a new vm with the project name
  # show the output of the command
  multipass launch --name $project_name
  multipass exec $project_name -- sudo apt update
  multipass exec $project_name -- sudo apt install -y xauth xorg
  # make key pair for this vm
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/${project_identity_file} -N ""
  # copy the public key to the vm
  public_key=$(cat ~/.ssh/${project_identity_file}.pub)
  multipass exec $project_name -- bash -c "echo \"$public_key\" >> ~/.ssh/authorized_keys"
}

# command: "delete" removes and purges a vm
delete() {
  project_name=$2
  project_identity_file="maqubes_${project_name}_rsa"
  echo "Deleting vm with the name: ${project_name}"
  # delete the vm with the project name
  multipass delete $project_name || true
  multipass purge || true
  rm ~/.ssh/${project_identity_file}* || true
  echo "Deleted vm with the name: ${project_name}"
}

# command: "install" installs an application in the vm
install() {
  # install $project_name $app_name
  project_name=$2
  app_name=$3
  project_identity_file="maqubes_${project_name}_rsa"

  # detect if the app_name looks like a file path
  if [ -f $app_name ]; then
    # copy the file to the vm
    echo "Copying the file ${app_name} to the ${project_name} vm"
    multipass transfer $app_name $project_name:/tmp/
    # get the file name from the path
    app_guest_path="/tmp/$(basename $app_name)"
    # install the file in the vm
    echo "Installing the file ${app_name} in the ${project_name} vm"
    multipass exec $project_name -- sudo apt install -y $app_guest_path
  else
    # error with unsupported
    echo "Unsupported application type: $app_name"
    exit 1
  fi
}

# command: "run" runs an application in the vm
run() {
  # run $project_name $app_name
  project_name=$2
  app_name=$3
  project_identity_file="maqubes_${project_name}_rsa"
  # ensure the vm is running
  multipass start $project_name
  ip_address=$(multipass info $project_name | grep 'IPv4' | awk '{print $2}')
  echo "Running the ${app_name} application in the ${project_name} vm"
  # run the application in the vm
  ssh -X -i ~/.ssh/${project_identity_file} ubuntu@${ip_address} "${app_name}"
}

# take a command name as the first argument
# and run a function with the same name
command_name=$1

# if the function does not exist, run the command
# if the command does not exist, print an error message
if [ "$(type -t $command_name)" == "function" ]; then
  $command_name "$@"
# elif [ "$(type -t $command_name)" == "file" ]; then
#   $command_name
else
  echo "Command not found: $command_name"
fi
