require 'rails_helper'

RSpec.describe ReversalTransaction, type: :model do

  context "on save" do
    it "gets 'error' status if initial transaction is not approved" do
      { "error" => "error",
        "reversed" => "error",
        "approved" => "approved",
      }.each do |initial_transaction_status, expected_status|
        initial_transaction = create(:authorize_transaction, status: initial_transaction_status)
        record = create(:reversal_transaction,
                         status: "approved",
                         authorize_transaction: initial_transaction,
                         merchant: initial_transaction.merchant)
        expect(record).to be_valid
        expect(record.status).to eq(expected_status)
      end
    end

    it "fails to create if a duplicate exists" do
      initial_transaction = create(:authorize_transaction)
      creation = -> { create(:reversal_transaction,
                             status: "approved",
                             authorize_transaction: initial_transaction,
                             merchant: initial_transaction.merchant) }
      expect { creation.call }.to change { described_class.count }.by(1) # with approved status
      expect { creation.call }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

end
