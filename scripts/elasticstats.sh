#!/bin/sh
##################################################################
# Creation: alasta
# Last Modification:
# Script de check Elasticsearch stats
##################################################################

###### VAR BEGIN
BIN_CURL=$(which curl)

#Default value
ELASTIC_SCHEME='http://'
OUTPUT_FORMAT='yaml'
VERSION="1.6"
HUMAN='human=false'
LIST_COMMAND=('info' 'indices' 'clusterhealth' 'clusterstats' 'nodestats' 'nodesettings' 'clustersettings' 'process' 'settings' 'license')
###### VAR END

###### SCRIPT BEGIN
# Help function
function f_help {
        echo ""
        echo "Description : Script to check Elasticsearch Stats."
        echo ""
        echo "Usage : `basename $0` [-h] [-S] [-D] -H <host> -P <port> [-p <proxypass path>] [-U <user> -W <password> or -w] -c <command info> [-o <output file>] [-f <output format>] [-V] [-u]"
        echo ""
        echo "   -h : Help"
        echo "   -D : Debug script"
        echo "   -S : Web Server is HTTPS"
        echo "   -H : Elasticsearch host - mandatory"
        echo "   -P : Elasticsearch port - mandatory"
        echo "   -p : Web Server proxypass if is set (set -P to listen port of Web Server) - mandatory"
        echo "	 -o : Output file"
        echo "   -c : Command :"
        echo "        - info"
        echo "        - indices"
        echo "        - clusterhealth"
        echo "        - clustersettings"
        echo "        - clusterstats"
        echo "        - license"
        echo "        - nodesettings"
        echo "        - nodestats"
        echo "        - process"
        echo "        - settings"
        echo "   -f : Output format :"
        echo "        - brute (without formatting)"
        echo " 	      - json"
        echo " 	      - yaml (default)"
        echo "	 -V : Version"
        echo "	 -u : Human (Statistics are returned in a format suitable for humans)"
        echo "	 -U : User"
        echo "	 -w : Prompt password"
        echo "	 -W : Password"
        echo ""
}

# Gestion des Options
while getopts ":hSDH:P:p:c:o:f:U:W:Vuw" option
do
        case $option in
                D)     set -x
                ;;
                H)      ELASTIC_HOST=$OPTARG
                ;;
                S)      ELASTIC_SCHEME='https://'
                ;;
                P)      ELASTIC_PORT=$OPTARG
                ;;
                p)      WS_PROXYPASS=$OPTARG
                ;;
                c)      C_COMMAND=$OPTARG
                        #Gestion de la valeur de l argument, on quitte si ce n est pas une valeur desiree
                        ${BASH_VERSION+shopt -s extglob}
                        #if [[ $C_COMMAND != "@(info|indices|clusterhealth|clusterstats|nodestats|nodesettings|clustersettings|process|settings)" ]]
                        if [[ ! ${LIST_COMMAND[@]} =~ ${C_COMMAND} ]] && [[ ! ${C_COMMAND}  == "_all"  ]]
                        then
                                echo "*** Commande \"$OPTARG\" unknown***"
                                exit 3
                        fi
                ;;
								f)			OUTPUT_FORMAT=$OPTARG
												#Gestion de la valeur de l argument, on quitte si ce n est pas une valeur desiree
												${BASH_VERSION+shopt -s extglob}
                        if [[ $OUTPUT_FORMAT != "@(brute|json|yaml)" ]]
                        then
                                echo "*** Commande \"$OPTARG\" unknown***"
                                exit 3
                        fi
								;;
                h)      f_help
                        exit 1
                ;;
                o)      OUTPUT_FILE=$OPTARG
                ;;
                V)      echo ${0} "version:" ${VERSION} 
                        exit 0
                ;;
                u)      HUMAN='human=true'
                ;;
                U)      C_USER=$OPTARG
                ;;
								w)			echo "Password : "
                        stty -echo
                        read
                        stty echo
                        C_PWD=$REPLY
								;;
                W)		C_PWD=$OPTARG	
                ;;
                \?)     echo "*** Error ***"
                        exit 3
                ;;
                :)      echo "*** Option \"$OPTARG\" not set ***"
                        exit 3
                ;;
                *)      echo "*** Option \"$OPTARG\" unknown ***"
                        exit 3
                ;;
        esac
done

#gestion du format de sortie
case $OUTPUT_FORMAT in
	brute)
		FORMAT='pretty=false'
	;;
	json)
		FORMAT='pretty=true'
	;;
	yaml)
		FORMAT='format=yaml'
	;;
esac

# definition des fonctions :
curl_function() {
	if [[ -z ${C_USER} ]]
	then
    $BIN_CURL -sk "${ELASTIC_SCHEME}${ELASTIC_HOST}:${ELASTIC_PORT}/${WS_PROXYPASS}/${1}&${HUMAN}"
	else
		$BIN_CURL -u ${C_USER}:${C_PWD} -sk "${ELASTIC_SCHEME}${ELASTIC_HOST}:${ELASTIC_PORT}/${WS_PROXYPASS}/${1}&${HUMAN}"
	fi
}

#gestion des commandes
case $C_COMMAND in
        info)
                RESULT=$(curl_function '?'${FORMAT})
        ;;
        indices)
                RESULT=$(curl_function '_cat/indices?v&'${FORMAT})
        ;;
        clusterhealth)
                RESULT=$(curl_function '_cluster/health?'${FORMAT})
        ;;
        clusterstats)
                RESULT=$(curl_function '_cluster/stats?'${FORMAT})
        ;;
        clustersettings)
                RESULT=$(curl_function '_cluster/settings?'${FORMAT})
        ;;
        nodestats)
                RESULT=$(curl_function '_nodes/stats?'${FORMAT})
        ;;
        nodesettings)
                RESULT=$(curl_function '_nodes/settings?'${FORMAT})
        ;;
        process)
                RESULT=$(curl_function '_nodes/process?'${FORMAT})
        ;;
        settings)
                RESULT=$(curl_function '_settings?'${FORMAT})
        ;;
        license)
                RESULT=$(curl_function '_license?'${FORMAT})
        ;;
        _all)
                RESULT="## Command info"$'\n'
								RESULT+=$(curl_function '?'${FORMAT})$'\n'
								RESULT+="## Command indices"$'\n'
								RESULT+=$(curl_function '_cat/indices?v&'${FORMAT})$'\n'
								RESULT+="## Command clusterhealth"$'\n'
								RESULT+=$(curl_function '_cluster/health?'${FORMAT})$'\n'
								RESULT+="## Command clusterstats"$'\n'
								RESULT+=$(curl_function '_cluster/stats?'${FORMAT})$'\n'
                RESULT+="## Command clustersettings"$'\n'
                RESULT+=$(curl_function '_cluster/settings?'${FORMAT})$'\n'
                RESULT+="## Command nodestats"$'\n'
                RESULT+=$(curl_function '_nodes/stats?'${FORMAT})$'\n'
                RESULT+="## Command nodesettings"$'\n'
                RESULT+=$(curl_function '_nodes/settings?'${FORMAT})$'\n'
                RESULT+="## Command process"$'\n'
                RESULT+=$(curl_function '_nodes/process?'${FORMAT})$'\n'
                RESULT+="## Command settings"$'\n'
                RESULT+=$(curl_function '_settings?'${FORMAT})$'\n'
                RESULT+="## Command license"$'\n'
                RESULT+=$(curl_function '_license?'${FORMAT})$'\n'
        ;;
esac



#affichage du resultat
if [ -z ${OUTPUT_FILE} ]
then
	echo  "#####=> Result to ${C_COMMAND}"
	echo  "${RESULT}"
else
	echo  "## Command : ${0} ${*}" > ${OUTPUT_FILE}
	echo  "#####=> Result to ${C_COMMAND}" >> ${OUTPUT_FILE}
	echo  "${RESULT}" >> ${OUTPUT_FILE}
	echo  "#####=> Result to ${C_COMMAND} in ${OUTPUT_FILE}"
fi
