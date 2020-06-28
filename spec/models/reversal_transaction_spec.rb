require 'rails_helper'

RSpec.describe ReversalTransaction, type: :model do

  context "on save" do
    it "gets 'error' status if initial transaction is not approved" do
      { "error" => "error",
        "reversed" => "error",
        "approved" => "approved",
      }.each do |parent_status, expected_status|
        parent = FactoryBot.create(:authorize_transaction, status: parent_status)
        record = FactoryBot.create(:reversal_transaction,
                                   status: "approved",
                                   authorize_transaction: parent,
                                   merchant: parent.merchant)
        expect(record).to be_valid
        expect(record.status).to eq(expected_status)
      end
    end

    it "fails to create if a duplicate exists" do
      parent = FactoryBot.create(:authorize_transaction)
      creation = -> { FactoryBot.create(:reversal_transaction,
                                 status: "approved",
                                 authorize_transaction: parent,
                                 merchant: parent.merchant) }
      creation.call # First call
      expect { creation.call }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

end
