class RefundTransaction < FollowOnTransaction

  alias_attribute :parent_transaction, :charge_transaction

  enum status: { approved: "approved", error: "error" }, _prefix: "status"

  belongs_to :charge_transaction, required: true, class_name: "ChargeTransaction", foreign_key: "initial_transaction_id", inverse_of: :refund_transaction

end
