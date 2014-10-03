#!/bin/bash

#-------------------------------------------------------------------------------
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#-------------------------------------------------------------------------------

# install and stop Cassandra
cat >> /etc/apt/sources.list.d/cassandra.sources.list << EOF
deb http://www.apache.org/dist/cassandra/debian 12x main
EOF
apt-get update
apt-get --force-yes -y install libcap2
apt-get --force-yes -y install cassandra
/etc/init.d/cassandra stop

# Set Cassandra heap size to something small
sed -i.bak "s/#MAX_HEAP_SIZE=\"4G\"/MAX_HEAP_SIZE=\"450m\"/" /etc/cassandra/cassandra-env.sh
sed -i.bak "s/#HEAP_NEWSIZE=\"800M\"/HEAP_NEWSIZE=\"100m\"/" /etc/cassandra/cassandra-env.sh

mkdir -p /mnt/data/cassandra
chown cassandra /mnt/data/cassandra
groovy config_cassandra.groovy > /etc/cassandra/cassandra.yaml

/etc/init.d/cassandra start
