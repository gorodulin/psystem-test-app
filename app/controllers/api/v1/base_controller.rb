
# Api::V1::BaseController
module Api::V1; class BaseController < ActionController::API
  include ActionController::MimeResponds

  before_action :set_merchant

  rescue_from ActionController::ParameterMissing do |e|
    error = ApplicationError::BadRequest.new(initial_exception: e, message: e.message)
    @errors = [error]
    render template: "api/v1/errors", status: error.http_status_code
  end


  private

  # TODO: replace with real authorization
  def set_merchant
    @merchant = Merchant.those_active.last
  end

end; end
