require "application_system_test_case"

class ActivitySubDivsTest < ApplicationSystemTestCase
  setup do
    @activity_sub_div = activity_sub_divs(:one)
  end

  test "visiting the index" do
    visit activity_sub_divs_url
    assert_selector "h1", text: "Activity Sub Divs"
  end

  test "creating a Activity sub div" do
    visit activity_sub_divs_url
    click_on "New Activity Sub Div"

    check "Active status" if @activity_sub_div.active_status
    fill_in "Activity div", with: @activity_sub_div.activity_div_id
    fill_in "Activity time", with: @activity_sub_div.activity_time
    fill_in "Amount", with: @activity_sub_div.amount
    fill_in "Classification", with: @activity_sub_div.classification
    fill_in "Comment", with: @activity_sub_div.comment
    check "Del status" if @activity_sub_div.del_status
    fill_in "User", with: @activity_sub_div.user_id
    click_on "Create Activity sub div"

    assert_text "Activity sub div was successfully created"
    click_on "Back"
  end

  test "updating a Activity sub div" do
    visit activity_sub_divs_url
    click_on "Edit", match: :first

    check "Active status" if @activity_sub_div.active_status
    fill_in "Activity div", with: @activity_sub_div.activity_div_id
    fill_in "Activity time", with: @activity_sub_div.activity_time
    fill_in "Amount", with: @activity_sub_div.amount
    fill_in "Classification", with: @activity_sub_div.classification
    fill_in "Comment", with: @activity_sub_div.comment
    check "Del status" if @activity_sub_div.del_status
    fill_in "User", with: @activity_sub_div.user_id
    click_on "Update Activity sub div"

    assert_text "Activity sub div was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity sub div" do
    visit activity_sub_divs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity sub div was successfully destroyed"
  end
end
