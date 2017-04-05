# README
Scripts to Elasticsearch operations

## es-operation.sh
Operation to ES index.  
[More infos](http://www.alasta.com/bigdata/2016/04/28/es-operations-script.html)
  
## elasticstats.sh
Stats to ES server.  
[More infos](http://www.alasta.com/bigdata/2016/04/28/es-stats-script.html)  
  
## es_clore_index.sh
#### Help
```shell
./es_clore_index.sh -h

Script to clore Elasticsearch index.
Usage : es_clore_index.sh [-h]  -d <date> 

   -h : Help
   -d : Date of Logstash index (2014.12.31 to logstash-2014.12.31)

```
  
#### Example
Close logstash index of 2014.09.10
```shell
./es_clore_index.sh -d 2014.09.10
{"acknowledged":true}
```
  
## es_delete_index.sh
#### Help
```shell
./es_delete_index.sh -h

Script to delete Elasticsearch index.
Usage : es_delete_index.sh [-h]  -d <date> 

   -h : Help
   -d : Date of Logstash index (2014.12.31 to logstash-2014.12.31)
```
  
#### Example
Delete logstash index of 2014.09.10
```shell
./es_delete_index.sh -d 2014.09.10
{"acknowledged":true}
```





## elasticstats.sh
#### Help
```shell
./elasticstats.sh -h

Description : Script to check Elasticsearch Stats.

Usage : elasticstats.sh [-h] [-S] [-D] -H <host> -P <port> -p <proxypass path> -c <command info> [-o <output file>]

   -h : Help
   -D : Debug script
   -S : Web Server is HTTPS
   -H : Elasticsearch host - mandatory
   -P : Elasticsearch port - mandatory
   -p : Web Server proxypass if is set (set -P to listen port of Web Server) - mandatory
   -c : Command :
        - info
        - indices
        - clusterhealth
        - clusterstats
        - nodestats
```

#### Example
- ES behind a reverse proxy 
```shell
./elasticstats.sh -S -H 1.1.1.1 -P 443 -p /es -c info
#####=> Result to info
{
  "name" : "node1,
  "cluster_name" : "Cluster",
  "version" : {
    "number" : "2.3.1",
    "build_hash" : "cd950929110aff804e7cb0827e61d0668869fc39",
    "build_timestamp" : "2016-04-04T12:25:05Z",
    "build_snapshot" : false,
    "lucene_version" : "5.5.0"
  },
  "tagline" : "You Know, for Search"
}
```
