class ChargeTransaction < FollowOnTransaction

  alias_attribute :initial_transaction, :authorize_transaction

  enum status: { approved: "approved", refunded: "refunded", error: "error" }, _prefix: "status"

  belongs_to :authorize_transaction, required: true, foreign_key: "initial_transaction_id"
  has_one :refund_transaction, -> { where.not(status: "error") }, class_name: "RefundTransaction", foreign_key: "initial_transaction_id", dependent: :destroy

  def can_be_refunded?
    status_approved?
  end

  private

  def set_status
    assign_attributes(status: "error") unless initial_transaction.can_be_charged?
  end

end
