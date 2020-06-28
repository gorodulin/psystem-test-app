require 'rails_helper'

RSpec.describe AuthorizeTransaction, type: :model do
  let(:record) { FactoryBot.create :authorize_transaction }

  it "sets initial_transaction_id to its id value" do
    id = SecureRandom.uuid
    record = FactoryBot.create(:authorize_transaction, id: id)
    expect(record.initial_transaction_id).to eq(id)
  end

end

