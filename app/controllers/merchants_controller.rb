class MerchantsController < ApplicationController

  before_action :set_merchant, only: [:edit, :update, :destroy]

  # GET /merchants
  def index
    @merchants = Merchant.all
  end

  # GET /merchants/1/edit
  def edit
  end

  # PATCH/PUT /merchants/1
  def update
    respond_to do |format|
      if @merchant.update(merchant_params)
        format.html { redirect_to merchants_path, notice: "Merchant was successfully updated." }
        format.json { render :show, status: :ok, location: @merchant }
      else
        format.html { render :edit }
        format.json { render json: @merchant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /merchants/1
  def destroy
    @merchant.destroy
    respond_to do |format|
      format.html { redirect_to merchants_url, notice: "Merchant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_merchant
      @merchant = Merchant.find(params[:id])
    end

    def merchant_params
      params.require(:merchant).permit(:name, :email, :is_active, :description)
    end
end
