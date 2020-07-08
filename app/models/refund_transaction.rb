class RefundTransaction < FollowOnTransaction

  alias_attribute :initial_transaction, :charge_transaction

  enum status: { approved: "approved", error: "error" }, _prefix: "status"

  belongs_to :charge_transaction, required: true, class_name: "ChargeTransaction", foreign_key: "initial_transaction_id", inverse_of: :refund_transaction

  private

  def set_status
    assign_attributes(status: "error") unless initial_transaction.can_be_refunded?
  end

end
