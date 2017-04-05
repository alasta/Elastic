# Templates ES pour Cacti

### Installation :
  
Mettre le script elasticstats4cacti.sh dans le dossier de scripts de Cacti, par défaut sur un RedHat Like c'est /var/lib/cacti/scripts.
  
```shell
cd /var/lib/cacti/scripts
wget https://raw.githubusercontent.com/alasta/elastic4cacti/master/elasticstats4cacti.sh
chmod +x elasticstats4cacti.sh
```
  
### Test du script
```shell
./elasticstats4cacti.sh -H 192.168.1.1 -P /my_elasticsearch -s shards
shards:102 pri:102 relo:0 init:0 unassign:76
```
  
### Intégration à Cacti
 
* Importer les différents templates dans **Import Templates**.
* Modifier dans **Input String** l'argument -P (path du ProxyPass) dans **Data Input Methods**, les **templates ElasticStack**.
* Appliquer les graphs aux serveurs ElasticSatack.

<HR>

# Templates ES to Cacti
  
### Installation :
  
Put the script in default cacti scripts folder, to Centos : /var/lib/cacti/scripts

```shell
cd /var/lib/cacti/scripts
wget https://raw.githubusercontent.com/alasta/elastic4cacti/master/elasticstats4cacti.sh
chmod +x elasticstats4cacti.sh
```
  
### Test the script
```shell
./elasticstats4cacti.sh -H 192.168.1.1 -P /my_elasticsearch -s shards
shards:102 pri:102 relo:0 init:0 unassign:76
```
  
### Integration to Cacti

Go to **Import templates** and import all template ElasticStack.  
Modify **Input String** (-P argument : ProxyPass of Elasticsearch) in **Data Input Methods, ElasticStack ...**.  
Apply the graph to ElasticStack host.  
 
