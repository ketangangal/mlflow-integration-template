# System upgrade
sudo apt-get update
sudo apt-get upgrade -y

# Docker Installation 
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo systemctl status docker

sudo usermod -aG docker ubuntu
newgrp docker

# Aws cli installation  [Configure with s3 full access RDS access]
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip

# Miniconda Installation -> base python version 3.9
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh
sudo reboot now


# Mlflow installation -> base python version 3.9 [with base activated in the terminal]
pip install mlflow
pip install boto3

mkdir mlflow-server-config
touch mlflow-server-config/launch-script.sh 
sudo nano mlflow-server-config/launch-script.sh 

# Content for launch script
    ##!/bin/bash  
mlflow server \
    --backend-store-uri sqlite:///mlflow.db \
    --default-artifact-root s3://mlflow-remote-artifact-store/ \
    --host 0.0.0.0 -p 8000


# If you want the Tracking server to be up and running after restarts and be resilient to failures.

sudo touch /etc/systemd/system/mlflow-server.service
sudo nano /etc/systemd/system/mlflow-server.service

    # [Unit]
    # Description=MLflow tracking server
    # After=network.target 

    # [Service]
    # Restart=on-failure
    # ExecStart=/bin/bash -c 'PATH=/home/ubuntu/miniconda3/bin/:$PATH exec /home/ubuntu/mlflow-server-config/launch-script.sh'

    # [Install]
    # WantedBy=multi-user.target

# Start the service 
sudo systemctl daemon-reload
sudo systemctl enable mlflow-server
sudo systemctl start mlflow-server
sudo systemctl status mlflow-server