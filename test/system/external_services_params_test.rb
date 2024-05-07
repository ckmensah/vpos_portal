require "application_system_test_case"

class ExternalServicesParamsTest < ApplicationSystemTestCase
  setup do
    @external_services_param = external_services_params(:one)
  end

  test "visiting the index" do
    visit external_services_params_url
    assert_selector "h1", text: "External services params"
  end

  test "should create external services param" do
    visit external_services_params_url
    click_on "New external services param"

    check "Active status" if @external_services_param.active_status
    fill_in "Company code", with: @external_services_param.company_code
    fill_in "Company url", with: @external_services_param.company_url
    check "Del status" if @external_services_param.del_status
    fill_in "Entity div code", with: @external_services_param.entity_div_code
    fill_in "Password", with: @external_services_param.password
    fill_in "User", with: @external_services_param.user_id
    fill_in "Username", with: @external_services_param.username
    click_on "Create External services param"

    assert_text "External services param was successfully created"
    click_on "Back"
  end

  test "should update External services param" do
    visit external_services_param_url(@external_services_param)
    click_on "Edit this external services param", match: :first

    check "Active status" if @external_services_param.active_status
    fill_in "Company code", with: @external_services_param.company_code
    fill_in "Company url", with: @external_services_param.company_url
    check "Del status" if @external_services_param.del_status
    fill_in "Entity div code", with: @external_services_param.entity_div_code
    fill_in "Password", with: @external_services_param.password
    fill_in "User", with: @external_services_param.user_id
    fill_in "Username", with: @external_services_param.username
    click_on "Update External services param"

    assert_text "External services param was successfully updated"
    click_on "Back"
  end

  test "should destroy External services param" do
    visit external_services_param_url(@external_services_param)
    click_on "Destroy this external services param", match: :first

    assert_text "External services param was successfully destroyed"
  end
end
