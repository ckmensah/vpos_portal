require "application_system_test_case"

class SuburbMastersTest < ApplicationSystemTestCase
  setup do
    @suburb_master = suburb_masters(:one)
  end

  test "visiting the index" do
    visit suburb_masters_url
    assert_selector "h1", text: "Suburb Masters"
  end

  test "creating a Suburb master" do
    visit suburb_masters_url
    click_on "New Suburb Master"

    check "Active status" if @suburb_master.active_status
    fill_in "City town", with: @suburb_master.city_town_id
    fill_in "Comment", with: @suburb_master.comment
    check "Del status" if @suburb_master.del_status
    fill_in "Suburb name", with: @suburb_master.suburb_name
    fill_in "User", with: @suburb_master.user_id
    click_on "Create Suburb master"

    assert_text "Suburb master was successfully created"
    click_on "Back"
  end

  test "updating a Suburb master" do
    visit suburb_masters_url
    click_on "Edit", match: :first

    check "Active status" if @suburb_master.active_status
    fill_in "City town", with: @suburb_master.city_town_id
    fill_in "Comment", with: @suburb_master.comment
    check "Del status" if @suburb_master.del_status
    fill_in "Suburb name", with: @suburb_master.suburb_name
    fill_in "User", with: @suburb_master.user_id
    click_on "Update Suburb master"

    assert_text "Suburb master was successfully updated"
    click_on "Back"
  end

  test "destroying a Suburb master" do
    visit suburb_masters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Suburb master was successfully destroyed"
  end
end
