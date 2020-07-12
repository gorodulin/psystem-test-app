json.success false
json.http_status response.status
json.errors {
  @errors.each do |error|
    json.extract! error, :code, :title, :message, :details
  end
}
