
# Api::V1::BaseController
module Api::V1; class BaseController < ActionController::API
  include ActionController::MimeResponds

  before_action :find_merchant

  rescue_from ActionController::ParameterMissing do |e|
    render_error :bad_request, :bad_request, details: e.message
  end


  private

  # TODO: replace with real authorization
  def find_merchant
    @merchant = Merchant.those_active.last
  end

  def render_error(status, error_code, extra = {})
    fail ArgumentError, "Symbol expected, #{status.class.name} given" unless status.is_a? Symbol
    status = ::Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    translate = ->(key) { I18n.t("api.v1.errors.#{error_code}.#{key}").presence }
    error = {
      status: status,
      code: translate[:code],
      title: translate[:title],
      description: translate[:description],
    }.compact.merge(extra)
    render_json_error(error)
  end

  def render_json_error(error)
    render json: { errors: [error] }, status: error[:status] and return
  end

end; end
