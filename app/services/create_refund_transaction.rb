class CreateRefundTransaction
  include Interactor

  def call
    attributes = context.to_h
      .slice(:amount, :merchant, :customer_email, :customer_phone)
      .merge \
        id: SecureRandom.uuid,
        charge_transaction: context.parent,
        status: context.parent.can_be_refunded? ? "approved" : "error"
    ActiveRecord::Base.transaction do
      context.transaction = RefundTransaction.new(attributes)
      context.transaction.tap do |o|
        o.save!
        break o unless o.status_approved?
        o.charge_transaction.update!(status: "refunded")
        o.merchant.decrement(:total_transaction_sum, o.amount).save!
      end
    end
  end

end
