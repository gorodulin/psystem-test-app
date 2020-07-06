require "rails_helper"

describe CreateTransaction do

  let(:merchant) { create(:merchant) }

  it "is callable" do
    expect(subject).to respond_to(:call)
  end

  describe ".call" do

    describe "with valid arguments" do

      it "creates authorize transactions" do
        attrs = attributes_for(:authorize_transaction).merge(type: "authorize", merchant: merchant)
        expect(described_class.call(**attrs)).to be_success
        expect {
          described_class.call(**attrs)
        }.to change { AuthorizeTransaction.count }.by(1)
      end

    end # ...describe

  end # ...describe

end
