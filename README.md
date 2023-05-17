# Secure MLflow server setup for production



![](images\secure_mlflow_server.png)


### Secret Mananger

In *Secret Manager* you need to configure secrets that the `mlflow` image will retrieve at boot time:

- `mlflow_artifact_url` - path to your *Cloud Storage* bucket, sample value `gs://mlflow`
- `mlflow_database_url` - SQLAlchemy-format *Cloud SQL* connection string (over internal *GCP* interfaces, not through IP), sample value `postgresql+pg8000://<dbuser>:<dbpass>@/<dbname>?unix_sock=/cloudsql/dlabs:europe-west3:mlfow/.s.PGSQL.5432`, the *Cloud SQL* instance name can be copied from *Cloud SQL* instance overview page
- `mlflow_tracking_username` - the basic HTTP auth username for `mlflow`, your choice, sample value `dlabs-developer`
- `mlflow_tracking_password` - the basic HTTP auth password for `mlflow`, your choice



#### Usage

```shell
docker build . -t mlflow

docker run --envs GCP_PROJECT=gcp-project-id -p 8080:8080 mlflow
```



#### Reference

- [mlflow-for-gcp](https://github.com/dlabsai/mlflow-for-gcp/tree/master)

- [A Step-by-step Guide To Setting Up MLflow On The Google Cloud Platform](https://dlabs.ai/blog/a-step-by-step-guide-to-setting-up-mlflow-on-the-google-cloud-platform/)
- [How to setup MLflow on Ubuntu](https://medium.com/data-folks-indonesia/how-to-setup-mlflow-in-ubuntu-d79ce47bee2e)
