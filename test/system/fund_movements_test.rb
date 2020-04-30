require "application_system_test_case"

class FundMovementsTest < ApplicationSystemTestCase
  setup do
    @fund_movement = fund_movements(:one)
  end

  test "visiting the index" do
    visit fund_movements_url
    assert_selector "h1", text: "Fund Movements"
  end

  test "creating a Fund movement" do
    visit fund_movements_url
    click_on "New Fund Movement"

    fill_in "Amount", with: @fund_movement.amount
    fill_in "Entity div code", with: @fund_movement.entity_div_code
    fill_in "Narration", with: @fund_movement.narration
    check "Processed" if @fund_movement.processed
    fill_in "Ref", with: @fund_movement.ref_id
    fill_in "Service", with: @fund_movement.service_id
    fill_in "Trans desc", with: @fund_movement.trans_desc
    fill_in "Trans status", with: @fund_movement.trans_status
    fill_in "Trans type", with: @fund_movement.trans_type
    click_on "Create Fund movement"

    assert_text "Fund movement was successfully created"
    click_on "Back"
  end

  test "updating a Fund movement" do
    visit fund_movements_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @fund_movement.amount
    fill_in "Entity div code", with: @fund_movement.entity_div_code
    fill_in "Narration", with: @fund_movement.narration
    check "Processed" if @fund_movement.processed
    fill_in "Ref", with: @fund_movement.ref_id
    fill_in "Service", with: @fund_movement.service_id
    fill_in "Trans desc", with: @fund_movement.trans_desc
    fill_in "Trans status", with: @fund_movement.trans_status
    fill_in "Trans type", with: @fund_movement.trans_type
    click_on "Update Fund movement"

    assert_text "Fund movement was successfully updated"
    click_on "Back"
  end

  test "destroying a Fund movement" do
    visit fund_movements_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fund movement was successfully destroyed"
  end
end
