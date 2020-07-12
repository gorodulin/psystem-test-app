require "rails_helper"

describe CreateTransaction do

  let(:merchant) { create(:merchant) }

  let(:authorize_transaction_attrs) do
    attributes_for(:authorize_transaction).merge(merchant: merchant)
  end

  it "is callable" do
    expect(subject).to respond_to(:call)
  end

  describe ".call" do

    describe "with invalid arguments" do

      it "returns failed result" do
        attrs = attributes_for(:authorize_transaction).merge(merchant: merchant)
        result = described_class.call(**attrs)
        expect(result).to be_success
        expect(result.error).to be_nil

        result = described_class.call(**attrs.merge(type: "badtype"))
        expect(result).to be_failure
        expect(result.error).to be_a(ApplicationError::WrongTransactionType)

        result = described_class.call(**attrs.merge(amount: nil))
        expect(result).to be_failure
        expect(result.error).to be_a(ApplicationError::WrongTransactionParameters)
      end

    end # ...describe

    describe "with valid arguments" do

      it "creates authorize transactions" do
        result, attrs = nil, authorize_transaction_attrs
        expect { result = described_class.call(**attrs) }.to change { AuthorizeTransaction.count }.by(1)
        expect(result).to be_success
        transaction = result.transaction
        expect(transaction).to have_attributes(attrs.except(:id, :type))
      end

      it "creates charge transactions" do
        authorize_transaction = described_class.call(**authorize_transaction_attrs).transaction
        expect(authorize_transaction.can_be_charged?).to be_truthy
        result, attrs = nil, authorize_transaction_attrs.merge(type: "ChargeTransaction", initial_transaction: authorize_transaction)

        # Create first charge transaction
        expect { result = described_class.call(**attrs) }.to change { ChargeTransaction.count }.by(1)
        expect(result).to be_success
        transaction = result.transaction
        expected_attrs = attrs
          .slice(:customer_phone, :customer_email, :amount)
          .merge(type: "ChargeTransaction", initial_transaction: authorize_transaction, status: "approved")
        expect(transaction).to have_attributes(expected_attrs)

        # Second charge transaction
        expect { result = described_class.call(**attrs) }.to change { ChargeTransaction.count }.by(1)
        expect(result).to be_success
        expect(result.transaction.status).to eq("error")

        # Third charge transaction
        expect { result = described_class.call(**attrs) }.to change { ChargeTransaction.count }.by(0)
        expect(result).to be_failure
        expect(result.transaction.status).to eq("error")
        expect(result.transaction).not_to be_persisted
      end

      xit "creates refund transaction" do
      end

      xit "creates reversal transaction" do
      end

    end # ...describe

  end # ...describe

end
