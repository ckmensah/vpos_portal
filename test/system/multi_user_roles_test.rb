require "application_system_test_case"

class MultiUserRolesTest < ApplicationSystemTestCase
  setup do
    @multi_user_role = multi_user_roles(:one)
  end

  test "visiting the index" do
    visit multi_user_roles_url
    assert_selector "h1", text: "Multi User Roles"
  end

  test "creating a Multi user role" do
    visit multi_user_roles_url
    click_on "New Multi User Role"

    check "Active status" if @multi_user_role.active_status
    fill_in "Comment", with: @multi_user_role.comment
    fill_in "Creator", with: @multi_user_role.creator_id
    check "Del status" if @multi_user_role.del_status
    fill_in "Entity code", with: @multi_user_role.entity_code
    fill_in "Role code", with: @multi_user_role.role_code
    fill_in "User", with: @multi_user_role.user_id
    click_on "Create Multi user role"

    assert_text "Multi user role was successfully created"
    click_on "Back"
  end

  test "updating a Multi user role" do
    visit multi_user_roles_url
    click_on "Edit", match: :first

    check "Active status" if @multi_user_role.active_status
    fill_in "Comment", with: @multi_user_role.comment
    fill_in "Creator", with: @multi_user_role.creator_id
    check "Del status" if @multi_user_role.del_status
    fill_in "Entity code", with: @multi_user_role.entity_code
    fill_in "Role code", with: @multi_user_role.role_code
    fill_in "User", with: @multi_user_role.user_id
    click_on "Update Multi user role"

    assert_text "Multi user role was successfully updated"
    click_on "Back"
  end

  test "destroying a Multi user role" do
    visit multi_user_roles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Multi user role was successfully destroyed"
  end
end
