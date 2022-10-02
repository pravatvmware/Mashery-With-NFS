#!/bin/bash

validate_all_json_files() {

for f in $(ls *.json 2>/dev/null); do 
  	jq '.' $f >/dev/null
  	if [ $? -ne 0 ]; then
  		echo "There is an error in the file $f."
  		return 1;
  	fi
done

}

validate_mysql_pwd (){

	if [ -f "tml_cluster_properties.json" ]; then
			CLUSTER_JSON=$(cat tml_cluster_properties.json)
			
			mysql_root_pwd=$(echo "$CLUSTER_JSON" | jq -r '.mysql_root_pwd')
			mysql_root_pwd_length=`echo -n $mysql_root_pwd | wc -m`
			mysql_masheryonprem_pwd=$(echo "$CLUSTER_JSON" | jq -r '.mysql_masheryonprem_pwd')
			mysql_masheryonprem_pwd_length=`echo -n $mysql_masheryonprem_pwd | wc -m`
			
			if [[ "$mysql_root_pwd" == "" ]] ; then
				echo "MySql root password can not be Blank. Please update $f file."
				return 1;
			fi
			if [[ "$mysql_masheryonprem_pwd" == "" ]] ; then
				echo "MySql masheryonprem password can not be Blank. Please update $f file."
				return 1;
			fi
			if  [[ "$mysql_root_pwd_length" -lt 8 ]] ; then
				echo "MySql root  password can not be less than 8 characters. Please update $f file."
				return 1;
			fi
			if  [[ "$mysql_masheryonprem_pwd_length" -lt 8 ]] ; then
				echo "MySql masheryonprem password can not be less than 8 characters. Please update $f file."
				return 1;
			fi
		fi
}

check_mom_details (){
	# in "tethered" mode, admin must specify "mom_key" and "mom_secret" in "tml_cluster_properties.json"
	if [[ "$TMG_CLUSTER_MODE" == 'tethered' ]]; then
		if [ -f "tml_cluster_properties.json" ]; then
			CLUSTER_JSON=$(cat tml_cluster_properties.json)
			MOM_KEY=$(echo "$CLUSTER_JSON" | jq -r '.mom_key')
			MOM_SECRET=$(echo "$CLUSTER_JSON" | jq -r '.mom_secret')
			if [[ "$MOM_KEY" == "" ]]; then
				echo "Please provide a valid Mom Key in tml_cluster_properties.json."
				return 1;
			fi
			if [[ "$MOM_SECRET" == "" ]]; then
				echo "Please provide a valid Mom Secret in tml_cluster_properties.json file."
				return 1;
			fi
		fi
	fi
}

remove_dependency_check_swarm (){
	IS_SWARM=`pwd | grep swarm`
	if [ "$IS_SWARM" != "" ]; then
	 for f in $(ls *.json 2>/dev/null); do 
  		mysed '/dependency_health_check/d' $f >/dev/null
	 done
	fi
}

validate_all_json_files
validate_mysql_pwd
check_mom_details
remove_dependency_check_swarm