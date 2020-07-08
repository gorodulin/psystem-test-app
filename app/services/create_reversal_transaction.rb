class CreateReversalTransaction
  include Interactor

  def call
    attributes = context.to_h
      .slice(:amount, :merchant, :customer_email, :customer_phone, :initial_transaction_id)
      .merge(id: SecureRandom.uuid, status: "approved")
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
