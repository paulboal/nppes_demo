# This builds a solrconfig for the appropriate environment.
# Please specify the specific core you want to refresh as $1.
#
$solrHost=localhost
$solrBase=/opt/lucidworks-hdpsearch/solr/server/solr
$solrCore=nppes

echo ">>> Unloading current core..."
curl "http://$solrHost:8983/solr/admin/cores?action=UNLOAD&core=$solrCore"

echo ">>> Removing old configuration from $solrCore"
rm -rf $solrBase/$solrCore

echo ">>> Copying new configuration to $solrCore"
scp -r ../solr/$1 solr@$solrHost:$solrBase/$solrCore
cp -r ./$solrCore $solrBase/

echo ">>> Creating new core..."
curl "http://$solrHost:8983/solr/admin/cores?action=CREATE&name=$solrCore&instanceDir=$solrBase/$solrCore&config=solrconfig.xml&schema=schema.xml&dataDir=data"
