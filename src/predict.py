from sklearn.model_selection import train_test_split
import pandas as pd
import numpy as np
import mlflow

# Model Location in artifact Registry 
logged_model = 'runs:/6a7145640f2a4c9d92acf46ed91a54f7/sklearn-model'

# Load model as a PyFuncModel.
loaded_model = mlflow.pyfunc.load_model(logged_model)


# Loading data to make Batch Prediction
data = pd.read_parquet(r"data/data.parquet")


features = data.drop(labels=['case_status', 'event_timestamp', "case_id"], axis=1)
labels = data['case_status']
labels= np.where(labels=='Denied', 1,0)

_, X_test, _ , y_test = train_test_split(features, labels, random_state=42)


predictions = loaded_model.predict(pd.DataFrame(X_test))
print(predictions)