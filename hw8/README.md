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



## Output Path

gs://hw8-ethan-1777149631/output/

## Local vs Distributed Execution

Local execution runs everything on one machine, while distributed execution on Dataproc Serverless runs the job across multiple executors. In the Spark UI, I could observe jobs, stages, task counts, and execution timelines that are harder to see in local mode. Operations such as joins and groupBy are more expensive because they involve shuffling data across executors.

## Codex Usage

Codex helped with small, bounded tasks such as improving filtering logic and translating a DataFrame-style aggregation into Spark SQL. I still reviewed the code manually and verified that the final script produced the expected outputs.
