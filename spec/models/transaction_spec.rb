require 'rails_helper'

RSpec.describe Transaction, type: :model do

  let(:merchant) { create :merchant }
  let(:record)   { build :transaction, merchant: merchant }

  it "requires customer phone" do
    expect(record).to be_valid
    record.customer_phone = "badly_formatted_phone"
    expect(record).to_not be_valid
  end

  it "requires customer email" do
    expect(record).to be_valid
    record.customer_email = "badly_formatted_email"
    expect(record).to_not be_valid
  end

  it "requires merchant to be active" do
    merchant = create :merchant, status: "inactive"
    authorize = build :authorize_transaction, merchant: merchant
    expect(authorize).not_to be_valid
    merchant.status = "active"
    expect(authorize).to be_valid
  end
end

