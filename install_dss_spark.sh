#!/bin/bash

set -ex

wget https://cdn.downloads.dataiku.com/public/dss/10.0.5/dataiku-dss-hadoop-standalone-libs-generic-hadoop3-10.0.5.tar.gz

wget https://cdn.downloads.dataiku.com/public/dss/10.0.5/dataiku-dss-spark-standalone-10.0.5-3.1.2-generic-hadoop3.tar.gz

~/dataiku-10.0.5-data/bin/dss stop

~/dataiku-10.0.5-data/bin/dssadmin install-hadoop-integration -standaloneArchive ~/dataiku-dss-hadoop-standalone-libs-generic-hadoop3-10.0.5.tar.gz

~/dataiku-10.0.5-data/bin/dssadmin install-spark-integration -standaloneArchive ~/
dataiku-dss-spark-standalone-10.0.5-3.1.2-generic-hadoop3.tar.gz

~/dataiku-10.0.5-data/bin/dss start
