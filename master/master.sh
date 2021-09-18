#!/bin/bash

export SPARK_MASTER_HOST=`hostname`

. "/spark/sbin/spark-config.sh"

. "/spark/bin/load-spark-env.sh"

mkdir -p $SPARK_MASTER_LOG

export SPARK_HOME=/spark

ln -sf /dev/stdout $SPARK_MASTER_LOG/spark-master.out

mkdir -p /root/.local/share/jupyter/kernels/pyspark
touch /root/.local/share/jupyter/kernels/pyspark/pyspark_kernel.template

cat >/root/.local/share/jupyter/kernels/pyspark/pyspark_kernel.template <<EOL
{
"display_name": ${KERNEL_NAME},
"language": "python",
"argv": [ ${PYSPARK_DRIVER_PYTHON}, "-m", "ipykernel", "-f", "{connection_file}" ],
"env": {
   "SPARK_HOME": ${SPARK_HOME},
   # sets the search path for importing python modules
   "PYTHONPATH": ${SPARK_HOME}/python/:${SPARK_HOME}/python/lib/py4j-0.10.9-src.zip,
   "PYSPARK_DRIVER_PYTHON": ${PYSPARK_DRIVER_PYTHON},
   "PYSPARK_PYTHON": ${PYSPARK_PYTHON},
   "PYSPARK_SUBMIT_ARGS": ${PYSPARK_SUBMIT_ARGS},
   # specifying the location to a python script, that will be run by python
   # before starting the python interactive mode (interpreter)
   "PYTHONSTARTUP": ${SPARK_HOME}/python/pyspark/shell.py
}
}
EOL

KERNEL_NAME=pyspark PYSPARK_DRIVER_PYTHON=/usr/bin/python3 SPARK_HOME=/spark PYSPARK_SUBMIT_ARGS="--master spark://spark-master:7077 pyspark-shell" cat /root/.local/share/jupyter/kernels/pyspark/pyspark_kernel.template | pyhocon -f json >> /root/.local/share/jupyter/kernels/pyspark/kernel.json

cd /spark/bin && /spark/sbin/../bin/spark-class org.apache.spark.deploy.master.Master \
    --ip $SPARK_MASTER_HOST --port $SPARK_MASTER_PORT --webui-port $SPARK_MASTER_WEBUI_PORT >> $SPARK_MASTER_LOG/spark-master.out
