require 'rails_helper'

RSpec.describe RefundTransaction, type: :model do

  context "on save" do
    it "gets 'error' status unless charge transaction is approved" do
      { "error" => "error",
        "refunded" => "error",
        "approved" => "approved",
      }.each do |initial_transaction_status, expected_status|
        initial_transaction = create(:charge_transaction, status: initial_transaction_status)
        record = create(:refund_transaction,
                         status: "approved",
                         charge_transaction: initial_transaction,
                         merchant: initial_transaction.merchant)
        expect(record).to be_valid
        expect(record.status).to eq(expected_status)
      end
    end

    it "fails to create if a duplicate exists" do
      initial_transaction = create(:charge_transaction)
      creation = -> { create(:refund_transaction,
                             status: "approved",
                             charge_transaction: initial_transaction,
                             merchant: initial_transaction.merchant) }
      expect { creation.call }.to change { described_class.count }.by(1) # with approved status
      expect { creation.call }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

end
