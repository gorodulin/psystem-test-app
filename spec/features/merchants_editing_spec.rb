require "rails_helper"

describe "editing merchants", type: :feature do

  before :each do
    5.times do
      FactoryBot.create :merchant
    end
  end

  it "visits editing form and edits the record" do
    new_attrs = { status: "inactive", email: "ghandi@example.com", name: "Ghandi" }

    visit "/merchants"
    Merchant.all.each do |merchant|
      expect(page).to have_content merchant.name
    end
    merchant = Merchant.last
    expect(merchant.name).not_to eq(new_attrs[:name])
    expect(merchant).to be_status_active
    click_link "edit_merchant_#{merchant.id}_link"
    expect(page).to have_content("Editing merchant")
    within("#edit_merchant_#{merchant.id}") do
      fill_in "merchant_email", with: new_attrs[:email]
      fill_in "merchant_name", with: new_attrs[:name]
      uncheck "is_active"
      click_button "update_action"
    end
    merchant.reload
    expect(page).to have_css("table#merchants_list tr", count: Merchant.count + 1)
    expect(merchant).to have_attributes(new_attrs)
  end

  xit "displays errors in response to invalid input" do
  end

end
