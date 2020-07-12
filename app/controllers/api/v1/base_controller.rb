
# Api::V1::BaseController
module Api::V1; class BaseController < ActionController::API
  include ActionController::MimeResponds

  before_action :authenticate_request

  rescue_from ActionController::ParameterMissing do |e|
    error = ApplicationError::BadRequest.new(initial_exception: e, message: e.message)
    @errors = [error]
    render template: "api/v1/errors", status: error.http_status_code
  end


  private

  def authenticate_request
    authenticated = AuthenticateApiRequest.call \
      request: request,
      party_finder: ->(decoded_token) { Merchant.find(decoded_token[:id]) }
    if authenticated.success?
      @merchant = authenticated.party
    else
      @errors = [authenticated.error]
      render_error_response(status: authenticated&.error&.http_status_code || 403)
    end
  end

  def render_error_response(status: 500)
    respond_to do |format|
      format.xml  { render(template: "api/v1/errors", status: status) and return }
      format.json { render(template: "api/v1/errors", status: status) and return }
    end
  end

end; end
