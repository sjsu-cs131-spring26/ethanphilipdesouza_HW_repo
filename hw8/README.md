# HW8 - PySpark Practice + Distributed Run on GCP + Codex CLI Warm-up

## Overview
This assignment uses PySpark to analyze NYC yellow taxi data and runs the job on Google Cloud Dataproc Serverless. The goal was to practice distributed data processing, cloud execution, and inspecting Spark jobs.

## Analysis A: Hourly Activity
This analysis groups trips by:
- Borough
- pickup hour

It outputs the total number of trips per Borough per hour.

## Analysis B: Fare / Tip Summary
This analysis groups trips by Borough and computes:
- total trip count
- average fare amount
- average tip amount

## Run Command

```bash
gcloud dataproc batches submit pyspark "$CODE_URI" \
  --region="$REGION" \
  --deps-bucket="gs://$BUCKET" \
  --properties="spark.dynamicAllocation.enabled=false,spark.executor.instances=4,spark.executor.cores=4,spark.executor.memory=4g"



