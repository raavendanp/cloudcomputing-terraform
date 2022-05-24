#!/bin/bash
#Execute . env_variables.sh
export TF_VAR_my_ip="$(curl ident.me)/32"
export TF_VAR_lab_region="us-east-1" 
export TF_VAR_lab_access_key="" 
export TF_VAR_lab_secret_key="" 
export TF_VAR_lab_token=""