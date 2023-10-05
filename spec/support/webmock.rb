require 'webmock/rspec'
WebMock.enable!

allowed_sites = ['http://elasticsearch:9200', 'http://localhost','http://localhost:9200']
WebMock.disable_net_connect!(allow: allowed_sites)

RSpec.configure do |config|
  config.include WebMock::API
end
