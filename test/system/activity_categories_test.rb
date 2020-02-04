require "application_system_test_case"

class ActivityCategoriesTest < ApplicationSystemTestCase
  setup do
    @activity_category = activity_categories(:one)
  end

  test "visiting the index" do
    visit activity_categories_url
    assert_selector "h1", text: "Activity Categories"
  end

  test "creating a Activity category" do
    visit activity_categories_url
    click_on "New Activity Category"

    check "Active status" if @activity_category.active_status
    fill_in "Activity cat desc", with: @activity_category.activity_cat_desc
    fill_in "Assigned code", with: @activity_category.assigned_code
    fill_in "Comment", with: @activity_category.comment
    check "Del status" if @activity_category.del_status
    fill_in "Image data", with: @activity_category.image_data
    fill_in "Image path", with: @activity_category.image_path
    fill_in "User", with: @activity_category.user_id
    click_on "Create Activity category"

    assert_text "Activity category was successfully created"
    click_on "Back"
  end

  test "updating a Activity category" do
    visit activity_categories_url
    click_on "Edit", match: :first

    check "Active status" if @activity_category.active_status
    fill_in "Activity cat desc", with: @activity_category.activity_cat_desc
    fill_in "Assigned code", with: @activity_category.assigned_code
    fill_in "Comment", with: @activity_category.comment
    check "Del status" if @activity_category.del_status
    fill_in "Image data", with: @activity_category.image_data
    fill_in "Image path", with: @activity_category.image_path
    fill_in "User", with: @activity_category.user_id
    click_on "Update Activity category"

    assert_text "Activity category was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity category" do
    visit activity_categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity category was successfully destroyed"
  end
end
