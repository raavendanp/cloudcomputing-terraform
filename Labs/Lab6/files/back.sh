#!/bin/bash
sudo yum update -y
sudo yum install -y gcc-c++ make 
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install -y nodejs 
