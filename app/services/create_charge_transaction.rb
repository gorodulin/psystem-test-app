class CreateChargeTransaction
  include Interactor

  def call
    attributes = context.to_h
      .slice(:amount, :merchant, :customer_email, :customer_phone)
      .merge \
        id: SecureRandom.uuid,
        authorize_transaction: context.parent,
        status: context.parent.can_be_charged? ? "approved" : "error"
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
