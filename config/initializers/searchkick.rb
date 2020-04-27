Searchkick.client = Elasticsearch::Client.new(
  hosts: ["elasticsearch:9200"],
  retry_on_failure: true,
  transport_options: { request: {timeout: 250} }
)
