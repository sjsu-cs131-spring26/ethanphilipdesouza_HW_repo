# Codex Notes

## Prompt 1
"Help me add filtering logic to remove invalid taxi records in PySpark"

## What Codex suggested
Codex suggested filtering rows based on fare amount and trip distance being greater than zero.

## What I accepted / edited / rejected
I accepted the filtering logic but adjusted it to also ensure location IDs were not null.

## What I verified myself
I verified that filtering worked correctly by ensuring the Spark job still ran and produced valid output.

---

## Prompt 2
"Convert a PySpark DataFrame aggregation into Spark SQL"

## What Codex suggested
Codex generated a SQL query using GROUP BY Borough with COUNT and AVG functions.

## What I accepted / edited / rejected
I accepted the SQL query and integrated it into my script using createOrReplaceTempView.

## What I verified myself
I verified that the SQL output matched expectations and successfully wrote to Parquet.
