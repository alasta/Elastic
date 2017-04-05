# POC ElasticSearch/Kibana v5.3

### Description :
This is the configuration to POC ES/Kibana behing a proxy on a same machine.

### Explain reverse proxy configuration :
Nginx in reverse proxy to :  
  /kibana     => localhost:5601  
  /clusteres  => first node ES and node 2 and 3 to backup  
  /cerebro    => optional, is to the fun  

### Configuration stack :
  
  - global
    - create a folder "poces"
    - go to this folder
    - SELinux in permissive to he POC
  - ElasticSearch
    - download ElasticSearch archive
    - extract archive
    - rename the folder to es-node01
    - copy entire folder es-node01 to es-node02 and es-node03
    - modify each elasticsearch.yml with setup provided
    - open a terminal on each es-node root folder (or tmux/tmuxinator)
      - modify JVM meory : export ES_JAVA_OPTS="-Xms512m -Xmx512m"
      - launch elasticsearch binary : ./bin/elasticsearch
  - Kibana
    - download Kibana archive
    - extract archive
    - go to kibana folder
    - modify each kibana.yml with setup provided
    - on the kibana root folder, launch kibana binary : ./bin/kibana
  - Nginx
    - modify the default.conf or other with setup provided (adapt your @IP in the configuration)
    - start/restart nginx 
  - Check
    - Open your browser to URL : http://@IP_SERVER/kibana
    - Play with your POC
   


### Version :
CentOS 7
Nginx : 1.10.3  
ElasticSearch : 5.3  
Kibana : 5.3  















