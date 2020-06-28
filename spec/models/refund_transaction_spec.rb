require 'rails_helper'

RSpec.describe RefundTransaction, type: :model do

  context "on save" do
    it "gets 'error' status unless charge transaction is approved" do
      { "error" => "error",
        "refunded" => "error",
        "approved" => "approved",
      }.each do |parent_status, expected_status|
        parent = FactoryBot.create(:charge_transaction, status: parent_status)
        record = FactoryBot.create(:refund_transaction,
                                   status: "approved",
                                   charge_transaction: parent,
                                   merchant: parent.merchant)
        expect(record).to be_valid
        expect(record.status).to eq(expected_status)
      end
    end

    it "fails to create if a duplicate exists" do
      parent = FactoryBot.create(:charge_transaction)
      creation = -> { FactoryBot.create(:refund_transaction,
                                 status: "approved",
                                 charge_transaction: parent,
                                 merchant: parent.merchant) }
      creation.call # First call
      expect { creation.call }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

end
