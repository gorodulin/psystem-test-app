class AuthenticateApiRequest
  include Interactor

  def call
    if decoded_auth_token
      context.party = context.party_finder.call(decoded_auth_token)
    end
  end

  private

  # @return [Hash]
  def decoded_auth_token
    @hash ||= JsonWebToken.decode(http_auth_header)
  rescue ::JWT::VerificationError => e
    context.fail!(error: ApplicationError::InvalidJwtToken.new(initial_exception: e))
  end

  def http_auth_header
    context.request.headers["Authorization"].presence \
    || context.fail!(error: ApplicationError::MissingAuthorizationHeader.new)
  end

end
