class Transaction < ApplicationRecord

  self.implicit_order_column = :created_at

  attr_readonly :initial_transaction_id, :merchant_id, :amount, :customer_email, :customer_phone, :created_at

  alias_attribute :uuid, :id

  belongs_to :merchant, inverse_of: :transactions

  validates :customer_phone, format: { with: /\A\+[0-9-]{6,18}\z/ }
  validates :customer_email, format: { with: ::URI::MailTo::EMAIL_REGEXP }

  validate :ensure_merchant_is_active

  scope :those_approved, -> { where(status: "approved") }
  scope :those_erroneous, -> { where(status: "error") }

  private

  def ensure_merchant_is_active
    errors.add(:merchant, "must be active") unless self.merchant.status_active?
  end

end

