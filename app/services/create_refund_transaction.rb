module CreateRefundTransaction

  def self.call(parent:, **opts)
    ActiveRecord::Base.transaction do
      options = {
        id: SecureRandom.uuid,
        charge_transaction: parent,
        status: parent.can_be_refunded? ? "approved" : "error",
      }.merge(opts)
      RefundTransaction.create!(options).tap do |o|
        break o unless o.status_approved?
        o.charge_transaction.update!(status: "refunded")
        o.merchant.decrement(:total_transaction_sum, o.amount).save!
      end
    end
  end

end
