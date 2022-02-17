require "application_system_test_case"

class UserRolesTest < ApplicationSystemTestCase
  setup do
    @user_role = user_roles(:one)
  end

  test "visiting the index" do
    visit user_roles_url
    assert_selector "h1", text: "User Roles"
  end

  test "creating a User role" do
    visit user_roles_url
    click_on "New User Role"

    check "Active status" if @user_role.active_status
    fill_in "Comment", with: @user_role.comment
    fill_in "Creator", with: @user_role.creator_id
    check "Del status" if @user_role.del_status
    fill_in "Division code", with: @user_role.division_code
    fill_in "Entity code", with: @user_role.entity_code
    check "For portal" if @user_role.for_portal
    fill_in "Role code", with: @user_role.role_code
    check "Show charge" if @user_role.show_charge
    fill_in "User", with: @user_role.user_id
    click_on "Create User role"

    assert_text "User role was successfully created"
    click_on "Back"
  end

  test "updating a User role" do
    visit user_roles_url
    click_on "Edit", match: :first

    check "Active status" if @user_role.active_status
    fill_in "Comment", with: @user_role.comment
    fill_in "Creator", with: @user_role.creator_id
    check "Del status" if @user_role.del_status
    fill_in "Division code", with: @user_role.division_code
    fill_in "Entity code", with: @user_role.entity_code
    check "For portal" if @user_role.for_portal
    fill_in "Role code", with: @user_role.role_code
    check "Show charge" if @user_role.show_charge
    fill_in "User", with: @user_role.user_id
    click_on "Update User role"

    assert_text "User role was successfully updated"
    click_on "Back"
  end

  test "destroying a User role" do
    visit user_roles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User role was successfully destroyed"
  end
end
