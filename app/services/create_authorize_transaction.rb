class CreateAuthorizeTransaction
  include Interactor

  def call
    attributes = context.to_h
      .slice(:amount, :merchant, :customer_email, :customer_phone)
      .merge \
        id: SecureRandom.uuid,
        status: "approved"
    context.transaction = AuthorizeTransaction.new(attributes)
    context.transaction.save!
  end

end
