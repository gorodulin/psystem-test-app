class ReversalTransaction < Transaction

  enum status: { approved: "approved", error: "error" }, _prefix: "status"

  validates :amount, absence: true

end
