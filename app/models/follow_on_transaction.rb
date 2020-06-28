class FollowOnTransaction < Transaction

  validates :amount,
    numericality: { greater_than: 0, equal_to: ->(t) { t.parent_transaction.amount } },
    unless: ->(t) { t.is_a?(ReversalTransaction) }

  validates :parent_transaction, presence: true

  validate  :check_if_merchant_is_the_same

  before_save :force_update_status


  private

  def check_if_merchant_is_the_same
    if self.merchant != self.parent_transaction.merchant
      errors.add(:merchant, "does not match merchant of parent transaction")
    end
  end

  def force_update_status
    return if parent_transaction.status.eql?("approved")
    assign_attributes(status: "error")
  end

end
