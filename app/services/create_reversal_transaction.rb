class CreateReversalTransaction
  include Interactor

  def call
    attributes = context.to_h
      .slice(:merchant, :customer_email, :customer_phone)
      .merge \
        id: SecureRandom.uuid,
        authorize_transaction: context.parent,
        status: context.parent.can_be_reversed? ? "approved" : "error"
    ActiveRecord::Base.transaction do
      context.transaction = ReversalTransaction.new(attributes)
      context.transaction.tap do |o|
        o.save!
        break o unless o.status_approved?
        o.authorize_transaction.update!(status: "reversed")
      end
    end
  end

end
