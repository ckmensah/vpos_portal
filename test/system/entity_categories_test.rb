require "application_system_test_case"

class EntityCategoriesTest < ApplicationSystemTestCase
  setup do
    @entity_category = entity_categories(:one)
  end

  test "visiting the index" do
    visit entity_categories_url
    assert_selector "h1", text: "Entity Categories"
  end

  test "creating a Entity category" do
    visit entity_categories_url
    click_on "New Entity Category"

    check "Active status" if @entity_category.active_status
    fill_in "Assigned code", with: @entity_category.assigned_code
    fill_in "Category name", with: @entity_category.category_name
    fill_in "Comment", with: @entity_category.comment
    check "Del status" if @entity_category.del_status
    fill_in "User", with: @entity_category.user_id
    click_on "Create Entity category"

    assert_text "Entity category was successfully created"
    click_on "Back"
  end

  test "updating a Entity category" do
    visit entity_categories_url
    click_on "Edit", match: :first

    check "Active status" if @entity_category.active_status
    fill_in "Assigned code", with: @entity_category.assigned_code
    fill_in "Category name", with: @entity_category.category_name
    fill_in "Comment", with: @entity_category.comment
    check "Del status" if @entity_category.del_status
    fill_in "User", with: @entity_category.user_id
    click_on "Update Entity category"

    assert_text "Entity category was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity category" do
    visit entity_categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity category was successfully destroyed"
  end
end
