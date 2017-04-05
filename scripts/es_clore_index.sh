#!/bin/sh

#################################################################
#
# Creation : Alasta - 20150917
# Desc : clore les index elasticsearch.
#
# Util : ./close_index.sh -d _date_de l_index_a_clore_
# Ex   : ./close_index.sh -d logstash-2015.09.02 => pour la date du 02/09/2015
#################################################################

#####BEGIN_VAR#####
BIN_DATE=$(which date)
BIN_CURL=$(which curl)

C_VAR_OK=0
#####END_VAR#####

#####BEGIN_SCRIPT#####
# Help function
function f_help {
        echo ""
        echo "Script to clore Elasticsearch index."
        echo "Usage : `basename $0` [-h]  -d <date> "
        echo ""
        echo "   -h : Help"
        echo "   -d : Date of Logstash index (2014.12.31 to logstash-2014.12.31)"
        echo ""
}

# Gestion des Options
while getopts ":hd:" option
do
        case $option in
                d)      C_DATE=$OPTARG
                        C_VAR_OK="1"
                ;;
                h)      f_help
                        exit 1
                ;;
                \?)     echo "*** Error ***"
                        exit $STATE_UNKNOWN
                ;;
                :)      echo "*** Option \"$OPTARG\" not set ***"
                        exit 3
                ;;
                *)      echo "*** Option \"$OPTARG\" unknown ***"
                        exit 3
                ;;
        esac
done

if [ $C_VAR_OK -eq "1" ]
then
  #Fermeture de l index
  $BIN_CURL -XPOST "http://localhost:9200/logstash-${C_DATE}/_close"
fi

#####END_SCRIPT#####
