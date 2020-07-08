class AuthorizeTransaction < Transaction

  enum status: { approved: "approved", reversed: "reversed", error: "error" }, _prefix: "status"

  has_one :reversal_transaction, class_name: "ReversalTransaction", foreign_key: "initial_transaction_id", dependent: :destroy
  has_one :charge_transaction, -> { where.not(status: "error") }, class_name: "ChargeTransaction", foreign_key: "initial_transaction_id", dependent: :destroy

  validates :amount, numericality: { greater_than: 0 }
  validates :initial_transaction_id, absence: true, if: ->(t) { t.new_record? }

  before_save do
    # This prevents initial_transaction_id field from being empty in database,
    # thus allows to validate at DB-level (via uniq index)
    # that every record has not more than one child record of a particular type
    self.initial_transaction_id = id
  end

  def can_be_reversed?
    ChargeTransaction.where(initial_transaction: self).where.not(status: "error").none? \
    && status_approved?
  end

  alias :can_be_charged? :can_be_reversed?

end
