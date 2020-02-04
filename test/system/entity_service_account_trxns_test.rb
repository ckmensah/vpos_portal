require "application_system_test_case"

class EntityServiceAccountTrxnsTest < ApplicationSystemTestCase
  setup do
    @entity_service_account_trxn = entity_service_account_trxns(:one)
  end

  test "visiting the index" do
    visit entity_service_account_trxns_url
    assert_selector "h1", text: "Entity Service Account Trxns"
  end

  test "creating a Entity service account trxn" do
    visit entity_service_account_trxns_url
    click_on "New Entity Service Account Trxn"

    check "Active status" if @entity_service_account_trxn.active_status
    fill_in "Charge", with: @entity_service_account_trxn.charge
    fill_in "Comment", with: @entity_service_account_trxn.comment
    check "Del status" if @entity_service_account_trxn.del_status
    fill_in "Entity div code", with: @entity_service_account_trxn.entity_div_code
    fill_in "Gross bal aft", with: @entity_service_account_trxn.gross_bal_aft
    fill_in "Gross bal bef", with: @entity_service_account_trxn.gross_bal_bef
    fill_in "Net bal aft", with: @entity_service_account_trxn.net_bal_aft
    fill_in "Net bal bef", with: @entity_service_account_trxn.net_bal_bef
    fill_in "Processing", with: @entity_service_account_trxn.processing_id
    fill_in "Trans type", with: @entity_service_account_trxn.trans_type
    fill_in "User", with: @entity_service_account_trxn.user_id
    click_on "Create Entity service account trxn"

    assert_text "Entity service account trxn was successfully created"
    click_on "Back"
  end

  test "updating a Entity service account trxn" do
    visit entity_service_account_trxns_url
    click_on "Edit", match: :first

    check "Active status" if @entity_service_account_trxn.active_status
    fill_in "Charge", with: @entity_service_account_trxn.charge
    fill_in "Comment", with: @entity_service_account_trxn.comment
    check "Del status" if @entity_service_account_trxn.del_status
    fill_in "Entity div code", with: @entity_service_account_trxn.entity_div_code
    fill_in "Gross bal aft", with: @entity_service_account_trxn.gross_bal_aft
    fill_in "Gross bal bef", with: @entity_service_account_trxn.gross_bal_bef
    fill_in "Net bal aft", with: @entity_service_account_trxn.net_bal_aft
    fill_in "Net bal bef", with: @entity_service_account_trxn.net_bal_bef
    fill_in "Processing", with: @entity_service_account_trxn.processing_id
    fill_in "Trans type", with: @entity_service_account_trxn.trans_type
    fill_in "User", with: @entity_service_account_trxn.user_id
    click_on "Update Entity service account trxn"

    assert_text "Entity service account trxn was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity service account trxn" do
    visit entity_service_account_trxns_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity service account trxn was successfully destroyed"
  end
end
