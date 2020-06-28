class ReversalTransaction < FollowOnTransaction

  alias_attribute :parent_transaction, :authorize_transaction

  enum status: { approved: "approved", error: "error" }, _prefix: "status"

  belongs_to :authorize_transaction, required: true, foreign_key: "initial_transaction_id", inverse_of: :reversal_transaction

  validates :amount, absence: true

end
