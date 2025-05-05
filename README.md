# SteamBench

## Load Data

- Download the dataset (https://storage.googleapis.com/abd25/data.zip) and extract it.

- Install the requirements:
  - With `pip`:
    ```shell
    pip3 install -r db/requirements.txt
    ```
  - With `apt`:
    ```shell
    apt install python3-psycopg2
    ```

- Install the `pgvector` extension: https://github.com/pgvector/pgvector?tab=readme-ov-file#installation

- Create a database to store the data.

- Load:
    ```shell
    # replace 'HOST', 'PORT', 'DBNAME', 'USER', and 'PASSWORD' with the
    # respective connection variables.
    python3 db/load.py --data data -H HOST -P PORT -d DBNAME -u USER -p PASSWORD
    ```


## Transactional workload (Java 21)

- Install:
```shell
cd transactional
mvn package
```

- Run:
```shell
# replace the connection, warmup, runtime, and client variables with the respective values
java -jar target/transactional-1.0-SNAPSHOT.jar -d jdbc:postgresql://HOST:PORT/DBNAME -U USER -P PASSWORD -W WARMUP -R RUNTIME -c CLIENTS
# E.g.:
java -jar target/transactional-1.0-SNAPSHOT.jar -d jdbc:postgresql://localhost:5432/steam -U postgres -P postgres -W 15 -R 180 -c 16
```


## Analytical workloads

The analytical queries can be found in the `analytical` folder.

- Prepare:
```shell
# Run the aux file (if present) to prepare the database for this query. (Only do this once)
# If some other aux file has a conflict with this one and you have previously run that file, 
# you may have to address the issue manually.
cd analytical
.\auxQx.sql
```

- Run:
```shell
# replace the query and n_executions variables with the respective values
python run_analytic_query.py query n_warm_ups n_executions
# E.g.:
python run_analytic_query.py Q3.sql 2 5
```