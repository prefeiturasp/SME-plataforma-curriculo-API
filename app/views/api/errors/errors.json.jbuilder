json.errors do
  json.request_path @request_path
  json.message      @message
  json.status       @response.status
end
