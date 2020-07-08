# TODO: Make sure instences of this class can't be saved
class FollowOnTransaction < Transaction

  validates! :initial_transaction, presence: true

  validate :validate_initial_transaction_persistence

  validates :amount,
    numericality: {
      greater_than: 0,
      message: "must be equal to initial transaction's amount",
      equal_to: ->(t) { t.initial_transaction.amount }
    },
    unless: ->(t) { t.is_a?(ReversalTransaction) }

  validate  :validate_merchant_is_the_same

  before_save :set_status


  private

  def validate_initial_transaction_persistence
    if self.initial_transaction.new_record?
      errors.add(:initial_transaction, "must persist in database")
    end
  end

  def validate_merchant_is_the_same
    if self.merchant != self.initial_transaction.merchant
      errors.add(:merchant, "does not match merchant of initial transaction")
    end
  end

end
