class User < ApplicationRecord

  has_one  :merchant, inverse_of: :user, required: false

  validates :email, format: { with: ::URI::MailTo::EMAIL_REGEXP }

  scope :those_admins, -> { where(is_admin: true) }
  scope :those_active_merchants, -> { joins(:merchant).where(merchants: { status: "active" }) }
  scope :those_inactive_merchants, -> { joins(:merchant).where(merchants: { status: "inactive" }) }

end
