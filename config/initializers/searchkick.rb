Searchkick.client = Elasticsearch::Client.new(
  hosts: [ENV['ELASTICSEARCH_URL']],
  retry_on_failure: true,
  transport_options: { 
    request: { timeout: 250 },
    ssl: { verify: false } # Ignora a verificação SSL
  }
)