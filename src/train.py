import pandas as pd
import numpy as np
import os

from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, roc_auc_score 

import mlflow
import mlflow.sklearn

from mlflow.models.signature import infer_signature
from mlflow.models.signature import ModelSignature


# Set tracking api 
mlflow.set_tracking_uri("http://13.232.137.83:8000/")


# Get details of experiment 
runid = mlflow.set_experiment(experiment_name="us-visa-knn")
print("Name :", runid.name)
print("Experiment Id :", runid.experiment_id)
print("Artifact Location :", runid.artifact_location)
print("Lifecycle Stage :", runid.lifecycle_stage)


# Evaluate model
def evaluate_clf(true, predicted):
    acc = accuracy_score(true, predicted) 
    f1 = f1_score(true, predicted) 
    precision = precision_score(true, predicted) 
    recall = recall_score(true, predicted)  
    roc_auc = roc_auc_score(true, predicted)
    return acc, f1 , precision, recall, roc_auc


def train(model):
    data = pd.read_parquet(r"data/data.parquet")

    features = data.drop(labels=['case_status', 'event_timestamp', "case_id"], axis=1)
    labels = data['case_status']
    labels= np.where(labels=='Denied', 1,0)

    X_train, X_test, y_train, y_test = train_test_split(features, labels, random_state=42)


    # Change run name according to the experiments that you are doing.
    with mlflow.start_run(experiment_id=runid.experiment_id, run_name="mlflow"):
        model.fit(X_train, y_train) 
        y_pred = model.predict(X_test)

        acc, f1 , precision, recall, roc_auc = evaluate_clf(y_test, y_pred)

        print("- Accuracy: {:.4f}".format(acc))
        print('- F1 score: {:.4f}'.format(f1)) 
        print('- Precision: {:.4f}'.format(precision))
        print('- Recall: {:.4f}'.format(recall))
        print('- Roc Auc Score: {:.4f}'.format(roc_auc))

        # Logging to Tracking server 
        mlflow.log_param("Accuracy", acc)
        mlflow.log_param("F1 score", f1) 
        mlflow.log_param("Precision", precision) 
        mlflow.log_param("Recall", recall) 
        mlflow.log_param("Roc Auc Score", roc_auc) 

        # Register Model Schema 
        signature = infer_signature(X_train, y_test)

        mlflow.sklearn.log_model(
            model, 
            artifact_path="sklearn-model" , 
            registered_model_name="knn", 
            signature=signature
            )

    # End the current Run      
    mlflow.end_run()
    return True

if __name__ == "__main__":
    # Change model According data understanding 
    knn = KNeighborsClassifier()
    train(knn)
