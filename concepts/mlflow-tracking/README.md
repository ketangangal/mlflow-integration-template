# Mlflow Tracking 

MLflow Tracking is organized around the concept of runs, which are executions of some piece of data science code. Each run records the following information:

```text
1. Code Version
2. Start & End Time
3. Source
4. Parameters
5. Metrics
6. Artifacts
```
## How runs are recoded

Scenario 5: MLflow Tracking Server enabled with proxied artifact storage access

## Mlflow Logging Use Full commands
It works under python api 

    1. mlflow.set_tracking_uri()
    2. mlflow.get_tracking_uri() 
    3. mlflow.create_experiment() 
    4. mlflow.set_experiment()
    5. mlflow.start_run() & mlflow.end_run()
    6. mlflow.log_param() & mlflow.log_metric() & mlflow.log_artifacts() & mlflow.log_artifact()
    7. mlflow.get_artifact_uri()

# Mlflow Local 

## Mlflow Build Docker

```python
mlflow models build-docker [OPTIONS]
    --model-uri <URI>
    --name <name>
    --env-manager <env_manager> # - local, Virtual, Conda
    --mlflow-home <PATH>
    --install-mlflow
    --enable-mlserver
```

```python 
mlflow models generate-dockerfile [OPTIONS]
    --model-uri <URI>
    --output-directory
    --env-manager <env_manager> # - local, Virtual, Conda
    --mlflow-home <PATH>
    --install-mlflow
    --enable-mlserver
```

## Mlflow Serve
Serve a model saved with MLflow by launching a webserver on the specified host and port.
```python
mlflow models serve [OPTIONS]
    --model-uri <URI>
    --port <port>
    --host <HOST>
    --timeout <timeout>
    --workers <workers>
    --env-manager <env_manager>
    --no-conda
    --install-mlflow
    --enable-mlserver
```

## Mlflow Predict 
Generate predictions in json format using a saved MLflow model.
```python
mlflow models predict [OPTIONS]
    --model-uri <URI> 
    --input-path <input_path> # CSV containing pandas DataFrame to predict against.
    --output-path <output_path> # File to output results to as json file. If not provided, stdout.
    --content-type <content_type>
    --env-manager <env_manager>
    --install-mlflow
```

## Deletion Behavior 
In order to allow MLflow Runs to be restored, Run metadata and artifacts are not automatically removed from the backend store or artifact store when a Run is deleted.

The mlflow gc CLI is provided for permanently removing Run metadata and artifacts for deleted runs.

```python
mlflow gc [OPTIONS]
    --older-than <older_than> 
    --backend-store-uri <PATH> 
    --run-ids <run_ids>
    --experiment-ids <experiment_ids>
```
# For More Information 
Refer : https://www.mlflow.org/docs/latest/cli.html#cli