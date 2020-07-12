 require "rails_helper"

RSpec.describe "/transactions", type: :request do

  let(:merchant) { create :merchant }
  let(:valid_payload) { attributes_for(:authorize_transaction).except(:id, :status) }
  let(:request_headers) do
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => JsonWebToken.encode(id: merchant.id)
    }
  end
  let(:response_content_type) { "application/json; charset=utf-8" }
  let(:parse) { ->(body) { JSON.parse(body) } }

  describe "POST /transactions" do

    describe "valid JSON payload" do

      it "requires valid JWT token" do
        request_headers.delete("Authorization")
        expect {
          post api_v1_transactions_url, params: valid_payload, headers: request_headers, as: :json
        }.to change(Transaction, :count).by(0)
        expect(response.content_type).to eq(response_content_type)
        expect { parse[response.body] }.not_to raise_error
        expect(response.status).to eq(401)
        expect(response.body).to include(*["10600", "Authorization header missing"])
      end

      it "renders JSON with successful response" do
        expect {
          post api_v1_transactions_url, params: valid_payload, headers: request_headers, as: :json
       }.to change(Transaction, :count).by(1)
        expect(response.content_type).to eq(response_content_type)
        expect { parse[response.body] }.not_to raise_error
        expect(response).to be_successful
      end

    end # ...describe

    describe "invalid JSON payload" do

      it "renders JSON on empty payload" do
        expect {
          post api_v1_transactions_url, params: {}, headers: request_headers, as: :json
       }.to change(Transaction, :count).by(0)
        expect(response.content_type).to eq(response_content_type)
        expect { parse[response.body] }.not_to raise_error
        expect(response.status).to eq(400)
        expect(response.body).to include(*["10400", "param is missing"])
      end

      it "renders JSON with successful response with meaningful errors" do
        msg = ->(a, b, p, r) { "expected #{a.inspect}, got #{b.inspect} for payload #{p.inspect}.\n Response: #{r.body.inspect}" }
        p = valid_payload
        invalid_payloads = {
          p.except(:type) => [422, 10200],
          p.except(:customer_phone) => [422, 10300],
          p.except(:customer_email) => [422, 10300],
          p.except(:amount) => [422, 10300],
          p.merge(customer_email: "dummy") => [422, 10300],
        }
        invalid_payloads.each_pair do |payload, consequences|
          http_code, error_code = *consequences
          post api_v1_transactions_url, params: payload, headers: request_headers, as: :json
          expect(response.content_type).to eq(response_content_type)
          expect { parse[response.body] }.not_to raise_error
          expect(response).to have_http_status(http_code), -> { msg[http_code, response.status, payload, response] }
          expect(response.body).to include(error_code.to_s)
        end
      end

    end # ...describe

  end # ...describe

end
