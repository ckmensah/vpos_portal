require "application_system_test_case"

class AssignedFeesTest < ApplicationSystemTestCase
  setup do
    @assigned_fee = assigned_fees(:one)
  end

  test "visiting the index" do
    visit assigned_fees_url
    assert_selector "h1", text: "Assigned Fees"
  end

  test "creating a Assigned fee" do
    visit assigned_fees_url
    click_on "New Assigned Fee"

    check "Active status" if @assigned_fee.active_status
    fill_in "Cap", with: @assigned_fee.cap
    fill_in "Charged to", with: @assigned_fee.charged_to
    fill_in "Comment", with: @assigned_fee.comment
    check "Del status" if @assigned_fee.del_status
    fill_in "Entity div code", with: @assigned_fee.entity_div_code
    fill_in "Fee", with: @assigned_fee.fee
    fill_in "Flat percent", with: @assigned_fee.flat_percent
    fill_in "Limit capped", with: @assigned_fee.limit_capped
    fill_in "Trans type", with: @assigned_fee.trans_type
    fill_in "User", with: @assigned_fee.user_id
    click_on "Create Assigned fee"

    assert_text "Assigned fee was successfully created"
    click_on "Back"
  end

  test "updating a Assigned fee" do
    visit assigned_fees_url
    click_on "Edit", match: :first

    check "Active status" if @assigned_fee.active_status
    fill_in "Cap", with: @assigned_fee.cap
    fill_in "Charged to", with: @assigned_fee.charged_to
    fill_in "Comment", with: @assigned_fee.comment
    check "Del status" if @assigned_fee.del_status
    fill_in "Entity div code", with: @assigned_fee.entity_div_code
    fill_in "Fee", with: @assigned_fee.fee
    fill_in "Flat percent", with: @assigned_fee.flat_percent
    fill_in "Limit capped", with: @assigned_fee.limit_capped
    fill_in "Trans type", with: @assigned_fee.trans_type
    fill_in "User", with: @assigned_fee.user_id
    click_on "Update Assigned fee"

    assert_text "Assigned fee was successfully updated"
    click_on "Back"
  end

  test "destroying a Assigned fee" do
    visit assigned_fees_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Assigned fee was successfully destroyed"
  end
end
