class JsonWebToken

  def self.encode(payload, expires: 24.hours.from_now) # TODO: 'expires' defaults should be moved to the app config
    payload[:exp] = Integer(expires)
    ::JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    ::JWT.decode(token, Rails.application.secrets.secret_key_base)
      .first
      .with_indifferent_access
  end

end
