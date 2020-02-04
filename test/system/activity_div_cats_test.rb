require "application_system_test_case"

class ActivityDivCatsTest < ApplicationSystemTestCase
  setup do
    @activity_div_cat = activity_div_cats(:one)
  end

  test "visiting the index" do
    visit activity_div_cats_url
    assert_selector "h1", text: "Activity Div Cats"
  end

  test "creating a Activity div cat" do
    visit activity_div_cats_url
    click_on "New Activity Div Cat"

    check "Active status" if @activity_div_cat.active_status
    fill_in "Comment", with: @activity_div_cat.comment
    check "Del status" if @activity_div_cat.del_status
    fill_in "Div cat desc", with: @activity_div_cat.div_cat_desc
    fill_in "Division code", with: @activity_div_cat.division_code
    fill_in "User", with: @activity_div_cat.user_id
    click_on "Create Activity div cat"

    assert_text "Activity div cat was successfully created"
    click_on "Back"
  end

  test "updating a Activity div cat" do
    visit activity_div_cats_url
    click_on "Edit", match: :first

    check "Active status" if @activity_div_cat.active_status
    fill_in "Comment", with: @activity_div_cat.comment
    check "Del status" if @activity_div_cat.del_status
    fill_in "Div cat desc", with: @activity_div_cat.div_cat_desc
    fill_in "Division code", with: @activity_div_cat.division_code
    fill_in "User", with: @activity_div_cat.user_id
    click_on "Update Activity div cat"

    assert_text "Activity div cat was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity div cat" do
    visit activity_div_cats_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity div cat was successfully destroyed"
  end
end
