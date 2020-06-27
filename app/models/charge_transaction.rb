class ChargeTransaction < Transaction

  enum status: { approved: "approved", refunded: "refunded", error: "error" }, _prefix: "status"

  scope :those_approved, -> { where(status: :approved) }

  validates :amount, numericality: { greater_than: 0 }

end
