# MLflow Model Registry
The MLflow Model Registry component is a centralized model store, set of APIs, and UI, to collaboratively manage the full lifecycle of an MLflow Model. It provides model lineage (which MLflow experiment and run produced the model), model versioning, stage transitions (for example from staging to production), and annotations.

The Model Registry introduces a few concepts that describe and facilitate the full lifecycle of an MLflow Model.

```text

1. Model : An MLflow Model is created from an experiment or run that is logged with one of the model flavor’s mlflow.<model_flavor>.log_model() methods. Once logged, this model can then be registered with the Model Registry.

2. Registered Model : An MLflow Model can be registered with the Model Registry. A registered model has a unique name, contains versions, associated transitional stages, model lineage, and other metadata.

3. Model Version : Each registered model can have one or many versions. When a new model is added to the Model Registry, it is added as version 1. Each new model registered to the same model name increments the version number.

4. Model Stage : Each distinct model version can be assigned one stage at any given time. MLflow provides predefined stages for common use-cases such as Staging, Production or Archived. You can transition a model version from one stage to another stage.

5. Annotations and Descriptions : You can annotate the top-level model and each version individually using Markdown, including description and any relevant information useful for the team such as algorithm descriptions, dataset employed or methodology.

```
## UI

## Mlflow Register Model 
An alternative way to interact with Model Registry is using the MLflow model flavor or MLflow Client Tracking API interface.
1. here are three programmatic ways to add a model to the registry. First, you can use the mlflow.<model_flavor>.log_model() method. In the code snippet, if a registered model with the name doesn’t exist, the method registers a new model and creates Version 1. If a registered model with the name exists, the method creates a new model version.

```python 
from random import random, randint
from sklearn.ensemble import RandomForestRegressor

import mlflow
import mlflow.sklearn

with mlflow.start_run(run_name="YOUR_RUN_NAME") as run:
    params = {"n_estimators": 5, "random_state": 42}
    sk_learn_rfr = RandomForestRegressor(**params)

    # Log parameters and metrics using the MLflow APIs
    mlflow.log_params(params)
    mlflow.log_param("param_1", randint(0, 100))
    mlflow.log_metrics({"metric_1": random(), "metric_2": random() + 1})

    # Log the sklearn model and register as version 1
    mlflow.sklearn.log_model(
        sk_model=sk_learn_rfr,
        artifact_path="sklearn-model",
        registered_model_name="sk-learn-random-forest-reg-model"
    )

```
2. The second way is to use the mlflow.register_model() method, after all your experiment runs complete and when you have decided which model is most suitable to add to the registry. For this method, you will need the run_id as part of the runs:URI argument.

```python
result = mlflow.register_model(
    "runs:/d16076a3ec534311817565e6527539c0/sklearn-model",
    "sk-learn-random-forest-reg"
)

```

3. you can use the create_registered_model() to create a new registered model. If the model name exists, this method will throw an MlflowException because creating a new registered model requires a unique name.

```python
from mlflow import MlflowClient

client = MlflowClient()
client.create_registered_model("sk-learn-random-forest-reg-model")


client = MlflowClient()
result = client.create_model_version(
    name="sk-learn-random-forest-reg-model",
    source="mlruns/0/d16076a3ec534311817565e6527539c0/artifacts/sklearn-model",
    run_id="d16076a3ec534311817565e6527539c0"
)
```
## Mlflow Fetch Model 

1. Fetch Latest Version To fetch a specific model version, just supply that version number as part of the model URI.

```python
import mlflow.pyfunc

model_name = "sk-learn-random-forest-reg-model"
model_version = 1

model = mlflow.pyfunc.load_model(
    model_uri=f"models:/{model_name}/{model_version}"
)

model.predict(data)
```
2. Fetch the latest model version in a specific stage

```python
import mlflow.pyfunc

model_name = "sk-learn-random-forest-reg-model"
stage = 'Staging'

model = mlflow.pyfunc.load_model(
    model_uri=f"models:/{model_name}/{stage}"
)

model.predict(data)

```
## Serve Mlflow Model 
Serving an MLflow Model from Model Registry
```python
#!/usr/bin/env sh

# Set environment variable for the tracking URL where the Model Registry resides
export MLFLOW_TRACKING_URI=http://localhost:5000

# Serve the production model from the model registry
mlflow models serve -m "models:/sk-learn-random-forest-reg-model/Production"

```
## Mlflow Additional Functions

### Adding or Updating an MLflow Model Descriptions
```python
from mlflow import MlflowClient
client = MlflowClient()
client.update_model_version(
    name="sk-learn-random-forest-reg-model",
    version=1,
    description="This model version is a scikit-learn random forest containing 100 decision trees"
)

```
### Renaming an MLflow Model
```python
client = MlflowClient()
client.rename_registered_model(
    name="sk-learn-random-forest-reg-model",
    new_name="sk-learn-random-forest-reg-model-100"
)

```
### Transitioning an MLflow Model’s Stage
```python
client = MlflowClient()
client.transition_model_version_stage(
    name="sk-learn-random-forest-reg-model",
    version=3,
    stage="Production"
)
```
### Listing and Searching MLflow Models
```python
client = MlflowClient()
for mv in client.search_model_versions("name='sk-learn-random-forest-reg-model'"):
    pprint(dict(mv), indent=4)
```
### Archiving an MLflow Model
```python
client = MlflowClient()
client.transition_model_version_stage(
    name="sk-learn-random-forest-reg-model",
    version=3,
    stage="Archived"
)

```
### Deleting MLflow Models
```python
client = MlflowClient()
versions=[1, 2, 3]
for version in versions:
    client.delete_model_version(name="sk-learn-random-forest-reg-model", version=version)

# Delete a registered model along with all its versions
client.delete_registered_model(name="sk-learn-random-forest-reg-model")
```