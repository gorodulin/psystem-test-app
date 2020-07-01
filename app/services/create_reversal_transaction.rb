module CreateReversalTransaction

  def self.call(parent:, **opts)
    ActiveRecord::Base.transaction do
      options = {
        id: SecureRandom.uuid,
        authorize_transaction: parent,
        status: parent.can_be_reversed? ? "approved" : "error",
      }.merge(opts.except(:amount))
      ReversalTransaction.create!(options).tap do |o|
        break o unless o.status_approved?
        o.authorize_transaction.update!(status: "reversed")
      end
    end
  end

end
