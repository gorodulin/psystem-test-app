class Merchant < ApplicationRecord

  enum status: { active: "active", inactive: "inactive" }, _prefix: "status"

  belongs_to :user, inverse_of: :merchant, required: true
  has_many :transactions, inverse_of: :merchant

  scope :those_active, -> { where(status: "active") }

  validates :email, format: { with: ::URI::MailTo::EMAIL_REGEXP }

  def is_active
    self.status == "active"
  end

  def is_active=(bool)
    self.status = ActiveRecord::Type::Boolean.new.cast(bool) ? "active" : "inactive"
  end

end
