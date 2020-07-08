# TODO: an Exception App is needed for custom http error pages

# Api::V1::TransactionsController
module Api::V1; class TransactionsController < BaseController

  # POST /api/v1/transactions
  def create
    result = CreateTransaction.call(transaction_params.to_h.symbolize_keys)

    respond_to do |format|
      if result.failure?
        status = result.error[:kind] || :bad_request
        format.json { render_error status, status, details: result.error.slice(:message, :details) }
      else
        format.json { render json: result.transaction.attributes, status: :created }
      end
    end
  end

  private

  def transaction_params
    permitted = %i[amount customer_email customer_phone initial_transaction_id type]
    params \
      .except(:transaction)
      .permit(permitted)
      .merge(merchant: @merchant)
  end

end; end
