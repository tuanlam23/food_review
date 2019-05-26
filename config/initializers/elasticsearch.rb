Elasticsearch::Model.client = Elasticsearch::Client.new url: "http://localhost:9200/"
Searchkick.client = Elasticsearch::Client.new(hosts: "http://localhost:9200/", retry_on_failure: true, transport_options: {request: {timeout: 250} })

# Elasticsearch::Model.client = Elasticsearch::Client.new url: ENV['ELASTICHSEARCH_URL']
# Searchkick.client = Elasticsearch::Client.new(hosts: ENV['ELASTICHSEARCH_URL'], retry_on_failure: true, transport_options: {request: {timeout: 250} })