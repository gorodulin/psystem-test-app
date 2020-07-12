# TODO: an Exception App is needed for custom http error pages

# Api::V1::TransactionsController
module Api::V1; class TransactionsController < BaseController

  # POST /api/v1/transactions
  def create
    result = CreateTransaction.call(transaction_params)
    @errors = Array.wrap(result.error)
    @transaction = result.transaction

    respond_to do |format|
      unless result.success?
        http_status = result&.error&.http_status_code || :bad_request
        format.xml  { render template: "api/v1/errors", status: http_status }
        format.json { render template: "api/v1/errors", status: http_status }
      else
        format.xml  { render status: :created }
        format.json { render status: :created }
      end
    end
  end

  private

  def transaction_params
    permitted = %i[amount customer_email customer_phone initial_transaction_id type]
    params \
      .require(:transaction)
      .permit(permitted)
      .merge(merchant: @merchant)
      .to_h
      .symbolize_keys
  end

end; end
