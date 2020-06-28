require 'rails_helper'

RSpec.describe Transaction, type: :model do

  let(:record) { FactoryBot.build :transaction }

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
end

