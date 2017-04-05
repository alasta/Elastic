# elastic4cacti
Voici un script et templates pour le monitoring ES dans Cacti :

- File descriptor
- Memory of Heap JVM
- Log rate
- Shards
  
## elasticstats4cacti.sh
  
```shell
./elasticstats4cacti.sh -h

ElasticStack - Stats for Cacti
Usage : elasticstats4cacti.sh [-D] [-h] [-v] [-S] -H <hostname> [-P <proxypass>] -s <stats command>

  -D | --debug : Enable debug script
  -h | --help : Read this help and exit
  -H | --hostname : ElasticStack host
  -P | --proxypass : Path of proxypass if ES is proxified (exemple : /path)
  -s | --stats : command of stats
    - filedescriptor
    - jvmheapuse
    - lograte
    - shards
  -S | --scheme : set scheme URL, default http
  -v | --version : Print version info and exit

```
  
### Log Rate argument
```shell
./elasticstats4cacti.sh -S -H 192.168.1.1 -P /my_elasticsearch -s lograte
lograte:2441191
```
_Note :_ C'est Cacti qui traduit la valeur en log/sec dans le graph.
  
### Argument File Descriptor 
```shell
./elasticstats4cacti.sh -S -H 192.168.1.1 -P /my_elasticsearch -s filedescriptor
open_FD:9582 max_FD:64000
```
  
### Argument jvmheapuse  
```shell
./elasticstats4cacti.sh -S -H 192.168.1.1 -P /my_elasticsearch -s jvmheapuse
heapusepercent:72
```
  
### Argument shards 
```shell
./elasticstats4cacti.sh -H 192.168.1.1 -P /my_elasticsearch -s shards
shards:102 pri:102 relo:0 init:0 unassign:76
```

<HR>



# elastic4cacti
Some scripts and templates to Cacti monitoring :
- File descriptor
- Memory of Heap JVM
- Log rate
- Shards
  
## elasticstats4cacti.sh
  
```shell
./elasticstats4cacti.sh -h

ElasticStack - Stats for Cacti
Usage : elasticstats4cacti.sh [-D] [-h] [-v] [-S] -H <hostname> [-P <proxypass>] -s <stats command>

  -D | --debug : Enable debug script
  -h | --help : Read this help and exit
  -H | --hostname : ElasticStack host
  -P | --proxypass : Path of proxypass if ES is proxified (exemple : /path)
  -s | --stats : command of stats
    - filedescriptor
    - jvmheapuse
    - lograte
    - shards
  -S | --scheme : set scheme URL, default http
  -v | --version : Print version info and exit

```
  
### Log Rate argument
```shell
./elasticstats4cacti.sh -S -H 192.168.1.1 -P /my_elasticsearch -s lograte
lograte:2441191
```
_Note :_ it's Cacti which translate this value in Log/Sec to the graph.
  
### File Descriptor argument
```shell
./elasticstats4cacti.sh -S -H 192.168.1.1 -P /my_elasticsearch -s filedescriptor
open_FD:9582 max_FD:64000
```
  
### jvmheapuse  argument
```shell
./elasticstats4cacti.sh -S -H 192.168.1.1 -P /my_elasticsearch -s jvmheapuse
heapusepercent:72
```
  
### shards  argument
```shell
./elasticstats4cacti.sh -H 192.168.1.1 -P /my_elasticsearch -s shards
shards:102 pri:102 relo:0 init:0 unassign:76
```
