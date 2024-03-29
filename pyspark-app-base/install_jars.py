# This script will copy all the files under jars to SPARK_HOME/jars
# If there is no SPARK_HOME, then use the path of the pyspark package

import os
import shutil

if __name__ == '__main__':
    env_spark_path = os.environ.get('SPARK_HOME')
    if env_spark_path:
        p = env_spark_path
    else:
        import pyspark

        p = pyspark.__path__[0]

    dir_prefix = os.path.abspath(os.path.dirname(__file__))
    jars_dir = os.path.join(dir_prefix, "./jars")
    jars = os.listdir(jars_dir)
    for jar in jars:
        print(f"CP {os.path.join(jars_dir, jar)} -> {os.path.join(p, './jars')}")
        shutil.copy(os.path.join(jars_dir, jar), os.path.join(p, './jars'))
