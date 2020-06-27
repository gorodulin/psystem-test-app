class Merchant < ApplicationRecord

  enum status: { active: "active", inactive: "inactive" }, _prefix: "status"

  belongs_to :user, inverse_of: :merchant, required: true
  has_many :transactions, inverse_of: :merchant

  validates :email, format: { with: ::URI::MailTo::EMAIL_REGEXP }

end
