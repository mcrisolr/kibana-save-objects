#!/bin/bash 

# ------------------------------- Additional save objects Kibana ---------------------- 

### https://www.elastic.co/guide/en/kibana/7.17/saved-objects-api-export.html

temporary_dump_path=/tmp/kibana/saved
mkdir $temporary_dump_path 

for object in {dashboard,index-pattern,visualization,config,url}

        do

        for kibana_panel in {kibana1,kibana2,kibana3} #Get multiples kibanas

                do

curl -k http://kibana-$kibana_panel:5601/api/saved_objects/_export -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "type": "'$object'",
  "includeReferencesDeep": true

}' > "$temporary_dump_path"/backup_"$kibana_panel"_"$object"_withReferences.ndjson # Includes all of the referenced objects in the exported objects.


#  Get only objects without references objects
curl -k http://kibana-$kibana_panel:5601/api/saved_objects/_export -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "type": "'$object'"

}' > "$temporary_dump_path"/backup_"$kibana_panel"_"$object".ndjson


# Get, show and count resume of backup objects
cat "$temporary_dump_path"/backup_"$kibana_panel"_$object.ndjson  | jq -c '.attributes.title' | grep -vi 'null' ; echo "----------- Total count of ${object^^} is $(cat "$temporary_dump_path"/backup_"$kibana_panel"_$object.ndjson | jq -c '.attributes.title' | wc  | awk '{print $1}')"

                done
        done
