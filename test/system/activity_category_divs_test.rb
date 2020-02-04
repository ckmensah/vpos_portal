require "application_system_test_case"

class ActivityCategoryDivsTest < ApplicationSystemTestCase
  setup do
    @activity_category_div = activity_category_divs(:one)
  end

  test "visiting the index" do
    visit activity_category_divs_url
    assert_selector "h1", text: "Activity Category Divs"
  end

  test "creating a Activity category div" do
    visit activity_category_divs_url
    click_on "New Activity Category Div"

    check "Active status" if @activity_category_div.active_status
    fill_in "Activity category", with: @activity_category_div.activity_category_id
    fill_in "Activity div cat", with: @activity_category_div.activity_div_cat_id
    fill_in "Category div desc", with: @activity_category_div.category_div_desc
    fill_in "Comment", with: @activity_category_div.comment
    check "Del status" if @activity_category_div.del_status
    fill_in "Division code", with: @activity_category_div.division_code
    fill_in "User", with: @activity_category_div.user_id
    click_on "Create Activity category div"

    assert_text "Activity category div was successfully created"
    click_on "Back"
  end

  test "updating a Activity category div" do
    visit activity_category_divs_url
    click_on "Edit", match: :first

    check "Active status" if @activity_category_div.active_status
    fill_in "Activity category", with: @activity_category_div.activity_category_id
    fill_in "Activity div cat", with: @activity_category_div.activity_div_cat_id
    fill_in "Category div desc", with: @activity_category_div.category_div_desc
    fill_in "Comment", with: @activity_category_div.comment
    check "Del status" if @activity_category_div.del_status
    fill_in "Division code", with: @activity_category_div.division_code
    fill_in "User", with: @activity_category_div.user_id
    click_on "Update Activity category div"

    assert_text "Activity category div was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity category div" do
    visit activity_category_divs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity category div was successfully destroyed"
  end
end
