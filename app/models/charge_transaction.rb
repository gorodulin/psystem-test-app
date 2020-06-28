class ChargeTransaction < FollowOnTransaction

  alias_attribute :parent_transaction, :authorize_transaction

  enum status: { approved: "approved", refunded: "refunded", error: "error" }, _prefix: "status"

  belongs_to :authorize_transaction, required: true, foreign_key: "initial_transaction_id", inverse_of: :charge_transaction
  has_one :refund_transaction, class_name: "RefundTransaction", foreign_key: "initial_transaction_id", dependent: :destroy

end
