class Transaction < ApplicationRecord

  self.primary_key = :uuid

  attr_readonly :initial_transaction_uuid, :merchant_id, :amount, :customer_email, :customer_phone, :created_at

  belongs_to :merchant, required: false, inverse_of: :transactions
  belongs_to :initial_transaction, optional: true, class_name: "Transaction",
    foreign_key: "initial_transaction_uuid", inverse_of: :referenced_transactions
  has_many   :referenced_transactions, class_name: "Transaction", inverse_of: :initial_transaction

  validates :customer_phone, format: { with: /\A\+[0-9-]{6,18}\z/ }
  validates :customer_email, format: { with: ::URI::MailTo::EMAIL_REGEXP }
  validate  :validate_initial_transaction_ownership, if: ->(t) { t.has_parent? }

  before_validation do
    if has_parent?
      self.status = "error" unless initial_transaction.status.in?(%w[approved refunded])
    end
  end

  def has_parent?
    self.initial_transaction.present? && initial_transaction_uuid != uuid
  end

  private

  def validate_initial_transaction_ownership
    errors.add(:merchant, "is wrong") unless self.merchant == self.initial_transaction.merchant
  end

end
