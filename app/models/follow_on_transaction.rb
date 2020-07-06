class FollowOnTransaction < Transaction

  validates :amount,
    numericality: {
      greater_than: 0,
      message: "must be equal to parent transaction's amount",
      equal_to: ->(t) { t.parent_transaction.amount }
    },
    unless: ->(t) { t.is_a?(ReversalTransaction) }

  validates :parent_transaction, presence: true

  validate  :check_if_merchant_is_the_same

  before_save :set_error_status


  private

  def check_if_merchant_is_the_same
    if self.merchant != self.parent_transaction.merchant
      errors.add(:merchant, "does not match merchant of parent transaction")
    end
  end

  def set_error_status
    return if parent_transaction.status.eql?("approved")
    assign_attributes(status: "error")
  end

end
