# MLflow Models 

An MLflow Model is a standard format for packaging machine learning models that can be used in a variety of downstream tools—for example, real-time serving through a REST API or batch inference on Apache Spark. The format defines a convention that lets you save a model in different “flavors” that can be understood by different downstream tools.

## Storage Format
Each MLflow Model is a directory containing arbitrary files, together with an MLmodel file in the root of the directory that can define multiple flavors that the model can be viewed in.
Flavors are the key concept that makes MLflow Models powerful: they are a convention that deployment tools can use to understand the model, which makes it possible to write tools that work with models from any ML library without having to integrate each tool with each library.
```yaml
# Directory written by mlflow.sklearn.save_model(model, "my_model")
my_model/
├── MLmodel
├── model.pkl
├── conda.yaml
├── python_env.yaml
└── requirements.txt
```

## Model Signature 
When working with ML models you often need to know some basic functional properties of the model at hand, such as “What inputs does it expect?” and “What output does it produce?”. MLflow models can include the following additional metadata about model inputs and outputs that can be used by downstream tooling:

The Model signature defines the schema of a model’s inputs and outputs. Model inputs and outputs can be either column-based or tensor-based. Column-based inputs and outputs can be described as a sequence of (optionally) named columns with type specified as one of the MLflow data types.

Refer: https://www.mlflow.org/docs/latest/models.html