class RefundTransaction < Transaction

  enum status: { approved: "approved", error: "error" }, _prefix: "status"

  validates :amount, numericality: { greater_than: 0, equal_to: ->(t) { t.initial_transaction.amount } }

end
