# Install Ngnix and apache2-utils

sudo apt install -y nginx
sudo apt-get install -y apache2-utils

# Configure ngnix as a reverse proxy to provide authentication layer on mlflow
sudo touch /etc/nginx/sites-enabled/mlflow
sudo nano /etc/nginx/sites-enabled/mlflow

server {
    listen 80;
    server_name 13.232.137.83;
    auth_basic “Administrator-Area”;
    auth_basic_user_file /etc/nginx/.htpasswd; 

    location / {
        proxy_pass http://localhost:8000;
        include /etc/nginx/proxy_params;
        proxy_redirect off;
    }
}

# Add username and Password [ Replace username with some name and in prompt add password]
sudo htpasswd -c /etc/nginx/.htpasswd USERNAME

# Enable service 

sudo systemctl restart nginx
sudo systemctl status nginx


# Keep these 2 in the env variables 
export MLFLOW_TRACKING_USERNAME=admin
export MLFLOW_TRACKING_PASSWORD=admin