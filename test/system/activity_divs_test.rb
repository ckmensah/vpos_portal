require "application_system_test_case"

class ActivityDivsTest < ApplicationSystemTestCase
  setup do
    @activity_div = activity_divs(:one)
  end

  test "visiting the index" do
    visit activity_divs_url
    assert_selector "h1", text: "Activity Divs"
  end

  test "creating a Activity div" do
    visit activity_divs_url
    click_on "New Activity Div"

    check "Active status" if @activity_div.active_status
    fill_in "Activity date", with: @activity_div.activity_date
    fill_in "Comment", with: @activity_div.comment
    check "Del status" if @activity_div.del_status
    fill_in "Division code", with: @activity_div.division_code
    fill_in "User", with: @activity_div.user_id
    click_on "Create Activity div"

    assert_text "Activity div was successfully created"
    click_on "Back"
  end

  test "updating a Activity div" do
    visit activity_divs_url
    click_on "Edit", match: :first

    check "Active status" if @activity_div.active_status
    fill_in "Activity date", with: @activity_div.activity_date
    fill_in "Comment", with: @activity_div.comment
    check "Del status" if @activity_div.del_status
    fill_in "Division code", with: @activity_div.division_code
    fill_in "User", with: @activity_div.user_id
    click_on "Update Activity div"

    assert_text "Activity div was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity div" do
    visit activity_divs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity div was successfully destroyed"
  end
end
