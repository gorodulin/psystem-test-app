require "ostruct"

module CreateChargeTransaction

  def self.call(parent:, **opts)
    result = OpenStruct.new(error: {})
    options = {
      id: SecureRandom.uuid,
      authorize_transaction: parent,
      status: parent.can_be_charged? ? "approved" : "error",
    }.merge(opts)
    ActiveRecord::Base.transaction do
      result.transaction = ChargeTransaction.new(options)
      result.transaction.tap do |o|
        o.save!
        break o unless o.status_approved?
        o.merchant.increment(:total_transaction_sum, o.amount).save!
      end
    end
    result
  rescue ActiveRecord::RecordInvalid => e
    result.error = { exception: e, message: "Wrong parameters", details: result.transaction.errors.messages }
    return result
  rescue ActiveRecord::RecordNotUnique => e
    result.error = { exception: e, message: "Duplicate transaction" }
    return result
  end

end
