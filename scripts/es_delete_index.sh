#!/bin/sh

#################################################################
#
# Creation : Alasta - 20160102
# Desc : suppression d index elasticsearch.
#
# Util : ./delete_index.sh -d _date_de l_index_a_supprimer_
# Ex   : ./delete_index.sh -d logstash-2015.09.02 => pour la date du 02/09/2015
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
        echo "Script to delete Elasticsearch index."
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
  #Suppression de l index
  $BIN_CURL -XDELETE "http://localhost:9200/logstash-${C_DATE}"
fi

#####END_SCRIPT#####

