#!/bin/sh
##################################################################
# Creation: alasta 20160428
# Desc : Elasticsearch operations
# Last Modification :
# Version : 0.1
##################################################################

###### VAR BEGIN
BIN_CURL=$(which curl)

#Default value
ELASTIC_SCHEME='http://'

###### VAR END

###### SCRIPT BEGIN
# Help function
function f_help {
        echo ""
        echo "Description : Script to Elasticsearch operations."
        echo ""
        echo "Usage : `basename $0` [-h] [-l] [-S] [-D] -H <host> -P <port> -p <proxypass path> -c <command operation> -i <index>"
        echo ""
        echo "   -h : Help"
        echo "   -D : Debug script"
        echo "   -S : Web Server is HTTPS"
        echo "   -H : Elasticsearch host - mandatory"
        echo "   -P : Elasticsearch port - mandatory"
        echo "   -p : Web Server proxypass if is set (set -P to listen port of Web Server) - mandatory"
        echo "   -c : Command :"
        echo "        - delete"
        echo "        - open"
        echo "        - close"
        echo "        - list"
        echo ""
        echo "   -i : index"
        echo ""
}

# Gestion des Options
while getopts ":hSDH:P:p:c:i:" option
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
								i)		  ELASTIC_INDEX=$OPTARG
                ;;
                c)      C_COMMAND=$OPTARG
                        #Gestion de la valeur de l argument, on quit si ce n est pas une valeur desiree
                        ${BASH_VERSION+shopt -s extglob}
                        if [[ $C_COMMAND != @(delete|open|close|list) ]]
                        then
                                echo "*** Commande \"$OPTARG\" unknown***"
                                exit 3
                        fi
                ;;
                h)      f_help
                        exit 1
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

#Index mandatory pour delete open close
if [[ $C_COMMAND == @(delete|open|close) ]]
then
	if [[ -z $ELASTIC_INDEX ]]
	then
		echo "Index is mandatory for this operation."
		exit 3
	fi
fi

# definition des fonctions :
curl_function() {
        $BIN_CURL -sk "${ELASTIC_SCHEME}${ELASTIC_HOST}:${ELASTIC_PORT}/${WS_PROXYPASS}/${1}"
}

curl_delete_function() {
        $BIN_CURL -XDELETE -sk "${ELASTIC_SCHEME}${ELASTIC_HOST}:${ELASTIC_PORT}/${WS_PROXYPASS}/${ELASTIC_INDEX}/"
}

curl_post_function() {
        $BIN_CURL -XPOST -sk "${ELASTIC_SCHEME}${ELASTIC_HOST}:${ELASTIC_PORT}/${WS_PROXYPASS}/${ELASTIC_INDEX}/${1}"
}


#gestion des commandes
case $C_COMMAND in
        list)
                RESULT=$(curl_function '_cat/indices?v')
        ;;
        delete)
                RESULT=$(curl_delete_function)
        ;;
        close)
                RESULT=$(curl_post_function '_close')
        ;;
        open)
                RESULT=$(curl_post_function '_open')
        ;;
esac

#affichage du resultat
echo -e "#####=> Result to ${C_COMMAND}"
echo -e "${RESULT}"
