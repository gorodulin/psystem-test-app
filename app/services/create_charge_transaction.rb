module CreateChargeTransaction

  def self.call(parent:, **opts)
    ActiveRecord::Base.transaction do
      options = {
        id: SecureRandom.uuid,
        authorize_transaction: parent,
        status: parent.can_be_charged? ? "approved" : "error",
      }.merge(opts)
      ChargeTransaction.create!(options).tap do |o|
        break o unless o.status_approved?
        o.merchant.increment(:total_transaction_sum, o.amount).save!
      end
    end
  end

end
