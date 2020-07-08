class CreateChargeTransaction
  include Interactor

  def call
    attributes = context.to_h
      .slice(:amount, :merchant, :customer_email, :customer_phone, :initial_transaction_id, :initial_transaction)
      .merge(id: SecureRandom.uuid, status: "approved")
    ActiveRecord::Base.transaction do
      context.transaction = ChargeTransaction.new(attributes)
      context.transaction.tap do |o|
        o.save!
        break o unless o.status_approved?
        o.merchant.increment(:total_transaction_sum, o.amount).save!
      end
    end
  end

end
