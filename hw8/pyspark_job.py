from pyspark.sql import SparkSession
from pyspark.sql.functions import col, hour, count

spark = SparkSession.builder.appName("HW8 Taxi Analysis").getOrCreate()

TRIPS_PATH = "gs://YOUR_BUCKET/data/yellow_tripdata_2022-01.parquet"
ZONES_PATH = "gs://YOUR_BUCKET/data/taxi_zone_lookup.csv"

OUTPUT_A = "gs://YOUR_BUCKET/output/hourly_activity"
OUTPUT_B = "gs://YOUR_BUCKET/output/fare_summary"

trips = spark.read.parquet(TRIPS_PATH)
zones = spark.read.option("header", True).csv(ZONES_PATH)

trips = trips.filter(
    (col("fare_amount") > 0) &
    (col("trip_distance") > 0) &
    col("PULocationID").isNotNull()
)

df = trips.join(
    zones,
    trips.PULocationID == zones.LocationID,
    "left"
)

hourly = (
    df.withColumn("pickup_hour", hour(col("tpep_pickup_datetime")))
      .groupBy("Borough", "pickup_hour")
      .agg(count("*").alias("trip_count"))
)

hourly.write.mode("overwrite").parquet(OUTPUT_A)

df.createOrReplaceTempView("taxi_data")

summary = spark.sql("""
SELECT
    Borough,
    COUNT(*) AS trip_count,
    AVG(fare_amount) AS avg_fare,
    AVG(tip_amount) AS avg_tip
FROM taxi_data
GROUP BY Borough
ORDER BY trip_count DESC
""")

summary.write.mode("overwrite").parquet(OUTPUT_B)

spark.stop()
