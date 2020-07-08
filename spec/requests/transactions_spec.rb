 require "rails_helper"

RSpec.describe "/transactions", type: :request do

  let(:valid_payload) {
    attributes_for(:authorize_transaction).except(:id, :status)
  }

  before do
    headers = { "ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json" }
  end


  describe "POST /transactions" do

    describe "valid payload" do

      it "renders JSON with successful response" do
        expect {
          post api_v1_transactions_url, params: valid_payload, headers: headers, as: :json
        }.to change(Transaction, :count).by(1)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect { JSON.parse(response.body) }.not_to raise_error
        expect(response).to be_successful
      end

    end # ...describe

    describe "invalid payload" do

      it "renders JSON with successful response with meaningful errors" do
        msg = ->(a, b, p, r) { "expected #{a.inspect}, got #{b.inspect} for payload #{p.inspect}.\n Response: #{r.body.inspect}" }
        p = valid_payload
        invalid_payloads = {
          p.except(:type) => [:bad_request, 20100],
          p.except(:customer_phone) => [:unprocessable_entity, 20103],
          p.except(:customer_email) => [:unprocessable_entity, 20103],
          p.except(:amount) => [:unprocessable_entity, 20103],
          p.merge(customer_email: "dummy") => [:unprocessable_entity, 20103],
        }
        invalid_payloads.each_pair do |payload, consequences|
          http_code, error_code = *consequences
          post api_v1_transactions_url, params: payload, headers: headers, as: :json
          expect(response.content_type).to eq("application/json; charset=utf-8")
          expect { JSON.parse(response.body) }.not_to raise_error
          expect(response).to have_http_status(http_code), -> { msg[http_code, response.status, payload, response] }
          expect(response.body).to include(error_code.to_s)
        end
      end

    end # ...describe

  end # ...describe

end
