require 'rails_helper'

RSpec.describe Merchant, type: :model do

  it "can be deleted only if there're no related transactions" do
    transaction = FactoryBot.create(:authorize_transaction)
    merchant = transaction.merchant
    expect {merchant.destroy!}.to raise_error(ActiveRecord::InvalidForeignKey)
    merchant.transactions.destroy_all
    expect {merchant.destroy!}.not_to raise_error
  end

end
