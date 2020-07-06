
# Api::V1::TransactionsController
module Api::V1; class TransactionsController < BaseController

  before_action :set_parent_transaction, only: [:create]

  # POST /api/v1/transactions
  def create
    @result = CreateTransaction.call(transaction_params.to_h.symbolize_keys)

    respond_to do |format|
      if @result.error.present?
        format.json { render_error :bad_request, :bad_request, details: @result.error.slice(:message, :details) }
      else
        format.json { render json: @result.transaction.attributes, status: :created }
      end
    end
  end

  private

    def set_parent_transaction
      @parent = @merchant.transactions.find(params[:parent])
    rescue ActiveRecord::RecordNotFound => e
      render_error :bad_request, :unknown_parent_transaction, uuid: params[:parent]
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params \
        .require(:transaction)
        .permit(:id, :type, :parent, :amount, :customer_email, :customer_phone)
        .merge(parent: @parent)
        .merge(merchant: @merchant)
    end

end; end
