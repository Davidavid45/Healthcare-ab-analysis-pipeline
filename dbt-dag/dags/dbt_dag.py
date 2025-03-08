from airflow import DAG
from datetime import datetime

from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig 
from cosmos.profiles import SnowflakeUserPasswordProfileMapping


profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping= SnowflakeUserPasswordProfileMapping(
        conn_id="snowflake_conn" ,
        profile_args={"database": "dbt_db", "schema": "dbt_schema"},
    )
) 

dbt_snowflake_dag = DbtDag(
    dag_id="dbt_dag",
    project_config=ProjectConfig("/usr/local/airflow/dags/dbt/data_pipeline"),
    profile_config=profile_config,
    operator_args={
        "install_deps": True,
        "dbt_executable_path": "/Users/oluwasegunadegoke/anaconda3/bin/dbt"
    },
    schedule_interval="@daily",
    start_date=datetime(2024, 3, 6),
    catchup=False,
)

dag = dbt_snowflake_dag