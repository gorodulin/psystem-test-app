# TODO: an Exception App is needed for custom http error pages

# Api::V1::TransactionsController
module Api::V1; class TransactionsController < BaseController

  # POST /api/v1/transactions
  def create
    result = CreateTransaction.call(transaction_params)
    @transaction, @error = result.to_h.values_at(:transaction, :error)

    respond_to do |format|
      if result.failure?
        status = result.error[:kind] || :bad_request
        format.xml { render }
        format.json { render_error status, status, details: @error.slice(:message, :details) }
      else
        format.xml  { render locals: { t: @transaction }, status: :created }
        #format.json { render json: @transaction.attributes, status: :created }
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
