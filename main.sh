#!/bin/bash



inv() {
    echo -e "\nInvalid"
    exit ${1:-1}
}


# ================ 1-policy ================================================= #
echo "
What kind of policy?
1. Interactive  
2. Job
"

read -p "Select number : " -n 1 policy

[ -z $policy ] && inv 1

if [ $policy == 1 ]
then
    policy=Interactive
elif [ $policy == 2 ]
then
    policy=Job
else
    inv 1
fi

# ================ 2-Environment ============================================ #
echo "


What Environment ?
1. PROD01 
2. SAS01 
3. DEV01
"

read -p "Select number : " -n 1 Environment

[ -z $Environment ] && inv 2

if [ $Environment == 1 ]
then
    Environment=PROD01
elif [ $Environment == 2 ]
then
    Environment=SAS01
elif [ $Environment == 3 ]
then
    Environment=DEV01
else
    inv 2
fi

# ================ 3-MOTS_ID ================================================ #
echo "


What is the MOTS ID?"

read -p "> " MOTS_ID

[ -z $MOTS_ID ] && inv 3

case $MOTS_ID in
    [0-9][0-9][0-9][0-9][0-9])
        :
        ;;
    *)
        inv 3
        ;;
esac

# ================ 4-BU ===================================================== #
echo "


What is the BU Name?"

read -p "> " BU

[ -z $BU ] && inv 4


# ================ 5-MIN_worker ============================================= #
echo "


Min Number of worker nodes?"

read -p "> " MIN_worker

[ -z $MIN_worker ] && inv 5

if ! [ $MIN_worker -gt 5 ] &> /dev/null; then
    inv 5
fi

# ================ 6-MAX_worker ============================================= #
echo "


Max Number of worker nodes?"
read -p "> " MAX_worker

[ -z $MAX_worker ] && inv 6

if [ $MAX_worker -lt $MIN_worker ]; then
    inv 6
fi

# ================ 7-auto_termination ======================================= #
if [[ $policy == 'Interactive' ]]
then
    echo "


Auto termination minutes ?"
    read -p "> " auto_termination

    [ -z $auto_termination ] && inv 7
    [ $auto_termination -ge 0 ] &> /dev/null || inv 7

# ================ ?-print data (Interactive) =============================== #
echo '

'$Environment.json'


{
    "spark_conf.spark.sql.hive.metastore.jars": {
      "type": "fixed",
      "value": "/dbfs/metastore/*",
      "hidden": true
    },

    "spark_conf.spark.sql.hive.metastore.version": {
      "type": "fixed",
      "value": "3.1.0",
      "hidden": true
    },

    "bu_name" : '\"$BU\"',

    "mots_id": {
        "id": '$MOTS_ID',
    },


    "min_worker": {
        "min_worker": '$MIN_worker',
    },
    

    "max_worker": {     
        "max_worker": '$MAX_worker',  
    },

 
    "termination_minutes": '$auto_termination'
}

'

else 
# ================ ?-print data (Job) ======================================= #
echo '

'$Environment.json'


{
    "spark_conf.spark.sql.hive.metastore.jars": {
      "type": "fixed",
      "value": "/dbfs/metastore/*",
      "hidden": true
    },

    "spark_conf.spark.sql.hive.metastore.version": {
      "type": "fixed",
      "value": "3.1.0",
      "hidden": true
    },

    "bu_name" : '\"$BU\"',

    "mots_id": {
        "id": '$MOTS_ID',
    },


    "min_worker": {
        "min_worker": '$MIN_worker',
    },
    

    "max_worker": {     
        "max_worker": '$MAX_worker',  
    },
}

'

fi
# ================ E  N  D ================================================== #