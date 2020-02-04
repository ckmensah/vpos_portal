require "application_system_test_case"

class EntityServiceAccountsTest < ApplicationSystemTestCase
  setup do
    @entity_service_account = entity_service_accounts(:one)
  end

  test "visiting the index" do
    visit entity_service_accounts_url
    assert_selector "h1", text: "Entity Service Accounts"
  end

  test "creating a Entity service account" do
    visit entity_service_accounts_url
    click_on "New Entity Service Account"

    check "Active status" if @entity_service_account.active_status
    fill_in "Comment", with: @entity_service_account.comment
    check "Del status" if @entity_service_account.del_status
    fill_in "Entity div code", with: @entity_service_account.entity_div_code
    fill_in "Gross bal", with: @entity_service_account.gross_bal
    fill_in "Net bal", with: @entity_service_account.net_bal
    fill_in "User", with: @entity_service_account.user_id
    click_on "Create Entity service account"

    assert_text "Entity service account was successfully created"
    click_on "Back"
  end

  test "updating a Entity service account" do
    visit entity_service_accounts_url
    click_on "Edit", match: :first

    check "Active status" if @entity_service_account.active_status
    fill_in "Comment", with: @entity_service_account.comment
    check "Del status" if @entity_service_account.del_status
    fill_in "Entity div code", with: @entity_service_account.entity_div_code
    fill_in "Gross bal", with: @entity_service_account.gross_bal
    fill_in "Net bal", with: @entity_service_account.net_bal
    fill_in "User", with: @entity_service_account.user_id
    click_on "Update Entity service account"

    assert_text "Entity service account was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity service account" do
    visit entity_service_accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity service account was successfully destroyed"
  end
end
