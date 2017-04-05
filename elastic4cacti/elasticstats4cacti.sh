#!/bin/sh
#################################################
# date creation : 2016-06-08
# last modification :
# description : ES stats for Cacti 
# creation : Alasta
#################################################

####BEGIN_VAR####
BIN_CURL="$(which curl) -sk"
BIN_GREP="$(which grep)"
BIN_SED="$(which sed)"
BIN_TR="$(which tr)"
BIN_AWK="$(which awk)"
URL_SCHEME="http://"

VERSION="1.1"

C_SPACE='  '
LIST_COMMAND=('lograte' 'shards' 'filedescriptor' 'jvmheapuse')

####END_VAR####
####BEGIN_SCRIPT####

# Help function
function f_help {
        echo ""
        echo "ElasticStack - Stats for Cacti"
        echo "Usage : $(basename $0) [-D] [-h] [-v] [-S] -H <hostname> [-P <proxypass>] -s <stats command>"
        echo ""
        echo "${C_SPACE}-D | --debug : Enable debug script"
        echo "${C_SPACE}-h | --help : Read this help and exit"
        echo "${C_SPACE}-H | --hostname : ElasticStack host"
        echo "${C_SPACE}-P | --proxypass : Path of proxypass if ES is proxified (exemple : /path)"
        echo "${C_SPACE}-s | --stats : command of stats"
				echo "${C_SPACE}${C_SPACE}- filedescriptor"
				echo "${C_SPACE}${C_SPACE}- jvmheapuse"
				echo "${C_SPACE}${C_SPACE}- lograte"
				echo "${C_SPACE}${C_SPACE}- shards"
        echo "${C_SPACE}-S | --scheme : set scheme URL, default http"
        echo "${C_SPACE}-v | --version : Print version info and exit"
        echo ""
}



OPTS=`getopt -o vhDSs:H:P: --long version,help,hostname,debug,proxypass,stats,scheme: -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

#echo "$OPTS"
#eval set -- "$OPTS"

while true; do
  case "$1" in
    -v | --version ) echo "Version de $(basename $0) : "${VERSION}; shift ;exit 0;;
    -h | --help )    f_help; shift ;exit 0;;
    -H | --hostname ) ELASTIC_HOST=$2; shift ; shift
            URL='/_nodes/'${ELASTIC_HOST}'/stats/process/?pretty&format=yaml'
        ;;
    -D | --debug ) set -x; shift ;;
    -P | --proxypass ) WS_PROXYPASS=$2; shift ; shift;;
    -S | --scheme ) URL_SCHEME='https://'; shift;;
		-s | --stats ) C_COMMAND=$2; shift; shift;
									#Gestion de la valeur de l argument, on quitte si ce n est pas une valeur desiree
                  ${BASH_VERSION+shopt -s extglob}
                  #if [[ $C_COMMAND != "@(filedescriptor|jvmheapuse|lograte|shards)" ]]
                  if [[ ! ${LIST_COMMAND[@]} =~ ${C_COMMAND} ]] && [[ ! ${C_COMMAND}  == "_all"  ]]
                  	then
                    echo "*** Commande \"$C_COMMAND\" unknown***"
                    exit 3
                   fi;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

# definition des fonctions :
curl_function() {
    $BIN_CURL "${URL_SCHEME}${ELASTIC_HOST}${WS_PROXYPASS}${1}"
}



##Get stats
#gestion des commandes
case $C_COMMAND in
	filedescriptor)
		URL='/_nodes/'${ELASTIC_HOST}'/stats/process/?pretty&format=yaml'
		# Translate file_descriptors to FD for cacti limitation in "Internal Data Source Name"
		RESULT=$(curl_function ${URL}  | ${BIN_GREP} file_descriptors | ${BIN_SED} -e 's/ //g' | ${BIN_TR} '\n' ' ' | ${BIN_SED} -e 's/file_descriptors/FD/g'
)
  ;;
	jvmheapuse)
		URL='/_cat/nodes?h=host,heap.percent'
		RESULT=$(curl_function ${URL} | ${BIN_AWK} '$1~/'${ELASTIC_HOST}'/ {print "heapusepercent:"$2}')
		
	;;
	lograte)
		URL='/_cat/count/*'${INDEX_PATTERN}'?h=count'
		RESULT=$(curl_function ${URL} | ${BIN_AWK} '{print "lograte:"$1}') 
	;;
	shards)
		URL="/_cat/health?h=shards,pri,relo,init,unassign"
		RESULT=$(curl_function ${URL} | ${BIN_AWK} '{print "shards:"$1, "pri:"$2, "relo:"$3, "init:"$4, "unassign:"$5}'
)
	;;
esac
				
#Display result
echo ${RESULT}

####END_SCRIPT####
