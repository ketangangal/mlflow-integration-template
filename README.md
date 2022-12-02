# mlflow-integration-template
MLflow is an open source platform to manage the ML lifecycle, including experimentation, reproducibility, deployment, and a central model registry. MLflow currently offers four components:

## MLflow Tracking Server enabled with proxied artifact storage access

![scenario_5](https://user-images.githubusercontent.com/40850370/205035297-676cd687-abcf-4de4-8a0f-0fe8eab98bf7.png)

1. MLflow Tracking : `Record and query experiments: code, data, config, and results`[https://www.mlflow.org/docs/latest/tracking.html]
2. MLflow Projects : `Package data science code in a format to reproduce runs on any platform.` [ https://www.mlflow.org/docs/latest/projects.html ]
3. MLflow Models   : `Deploy machine learning models in diverse serving environments.` [ https://www.mlflow.org/docs/latest/models.html]
4. Model Registry  : `Store, annotate, discover, and manage models in a central repository.`[ https://www.mlflow.org/docs/latest/model-registry.html ]

# MLflow Tracking Code
The MLflow Tracking component is an API and UI for logging parameters, code versions, metrics, and output files when running your machine learning code and for later visualizing the results. MLflow Tracking lets you log and query experiments using Python, REST, R API, and Java API APIs.

# Mlflow Production Server Setup [ aws s3 + mysql ]
### AWS 
1. Aws Account with billing setup
2. Backend Store [Mysql Server]: It stores (runs, parameters, metrics, tags, notes, metadata, etc)
3. Artifacts Store [S3 Bucket ]: It stores (files, models, images, in-memory objects, or model summary, etc).

### Ec2 Instance configuration 
```yaml
region:
    name: ap-south-1

machine-configuration:
    platform: ubuntu-jammy-22.04
    storage: /dev/sda1 [50 GB]
    instance_type: t2.small/medium/large [as per required]
    port-to-open: 8000 TCP port
    ip-range: 0.0.0.0/0

key-pair: 
    name: mlflow
    store: somewhere safe

```

### Mysql Database Configuration
```yaml
region:
    name: ap-south-1

machine-configuration:
    mysql-version: 8.0.30
    tier: as-per-required 
    username: admin
    password: open-source
    storage: as-per-required
    auto-scaling: enable
    vpc: default 
    subnet: default
    public-access: Yes
    port: 3306
    additional-configuration:
        database_name: mlflowdb
    
security:
    port-to-open: all traffic 
    ip-range: 0.0.0.0/0

```

### Connection Test 
```yaml
local:
    mysql-workbench:
        database-endpoint: 
        username: machine-configuration[username]
        pass: machine-configuration[pass]
        dbname: machine-configuration[additional-configuration][database_name]

final: mysql://username:pass@endpoint/DB-name 
```

## Steps to follow 

Navigate to scripts/mlflow-server-setup.sh

    1. Upgrade the system 
    2. Install Aws cli 
    3. Install anaconda
    4. Create new env [ mlflow ]
    5. launch mlflow as a service 
    6. reload the system 

Navigate to scripts/authenticate-mlflow.sh

    1. Install engnix 
    2. Create Ngnix service 
    3. set username and password
    4. Restart the ngnix service
    5. EXPORT the username and password in client env:
    6. Enjoy

### Conclusion 
we have just completed the production setup of the mlflow enviorment. To scale up automatically use kubernetes or aws Fargate.
resource link: https://aws.amazon.com/blogs/machine-learning/managing-your-machine-learning-lifecycle-with-mlflow-and-amazon-sagemaker/






