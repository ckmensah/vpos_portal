require "application_system_test_case"

class AssignedServiceCodesTest < ApplicationSystemTestCase
  setup do
    @assigned_service_code = assigned_service_codes(:one)
  end

  test "visiting the index" do
    visit assigned_service_codes_url
    assert_selector "h1", text: "Assigned Service Codes"
  end

  test "creating a Assigned service code" do
    visit assigned_service_codes_url
    click_on "New Assigned Service Code"

    check "Active status" if @assigned_service_code.active_status
    fill_in "Comment", with: @assigned_service_code.comment
    check "Del status" if @assigned_service_code.del_status
    fill_in "Entity div code", with: @assigned_service_code.entity_div_code
    fill_in "Service code", with: @assigned_service_code.service_code
    fill_in "User", with: @assigned_service_code.user_id
    click_on "Create Assigned service code"

    assert_text "Assigned service code was successfully created"
    click_on "Back"
  end

  test "updating a Assigned service code" do
    visit assigned_service_codes_url
    click_on "Edit", match: :first

    check "Active status" if @assigned_service_code.active_status
    fill_in "Comment", with: @assigned_service_code.comment
    check "Del status" if @assigned_service_code.del_status
    fill_in "Entity div code", with: @assigned_service_code.entity_div_code
    fill_in "Service code", with: @assigned_service_code.service_code
    fill_in "User", with: @assigned_service_code.user_id
    click_on "Update Assigned service code"

    assert_text "Assigned service code was successfully updated"
    click_on "Back"
  end

  test "destroying a Assigned service code" do
    visit assigned_service_codes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Assigned service code was successfully destroyed"
  end
end
