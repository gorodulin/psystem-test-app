class ReversalTransaction < FollowOnTransaction

  alias_attribute :initial_transaction, :authorize_transaction

  enum status: { approved: "approved", error: "error" }, _prefix: "status"

  belongs_to :authorize_transaction, required: true, foreign_key: "initial_transaction_id", inverse_of: :reversal_transaction

  validates :amount, absence: true

  private

  def set_status
    assign_attributes(status: "error") unless initial_transaction.can_be_reversed?
  end

end
