module CreateAuthorizeTransaction

  def self.call(**opts)
    options = {
      id: SecureRandom.uuid,
      status: "approved",
    }.merge(opts.except(:parent))
    AuthorizeTransaction.create!(options)
  end

end
