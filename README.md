# mlflow-integration-template
MLflow is an open source platform to manage the ML lifecycle, including experimentation, reproducibility, deployment, and a central model registry. MLflow currently offers four components:

1. MLflow Tracking : `Record and query experiments: code, data, config, and results`
2. MLflow Projects : `Package data science code in a format to reproduce runs on any platform.`
3. MLflow Models   : `Deploy machine learning models in diverse serving environments.`
4. Model Registry  : `Store, annotate, discover, and manage models in a central repository.`

# MLflow Tracking Code and Examples
The MLflow Tracking component is an API and UI for logging parameters, code versions, metrics, and output files when running your machine learning code and for later visualizing the results. MLflow Tracking lets you log and query experiments using Python, REST, R API, and Java API APIs.

# Mlflow Production Server Setup [ aws s3 + mysql ]
### AWS 
1. Aws Account with billing setup
2. Backend Store [Mysql Server]: It stores (runs, parameters, metrics, tags, notes, metadata, etc)
3. Artifacts Store [S3 Bucket ]: It stores (files, models, images, in-memory objects, or model summary, etc).








