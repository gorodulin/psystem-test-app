require "rails_helper"

describe "listing merchants", type: :feature do

  before :each do
    5.times do
      FactoryBot.create :merchant
    end
  end

  it "displays a full list of merchants w/o pagination" do
    visit "/merchants"
    Merchant.all.each do |merchant|
      expect(page).to have_content merchant.name
    end
    expect(page).to have_css("table#merchants_list tr", count: Merchant.count + 1)
  end

end
