require "application_system_test_case"

class CityTownMastersTest < ApplicationSystemTestCase
  setup do
    @city_town_master = city_town_masters(:one)
  end

  test "visiting the index" do
    visit city_town_masters_url
    assert_selector "h1", text: "City Town Masters"
  end

  test "creating a City town master" do
    visit city_town_masters_url
    click_on "New City Town Master"

    check "Active status" if @city_town_master.active_status
    fill_in "City town name", with: @city_town_master.city_town_name
    fill_in "Comment", with: @city_town_master.comment
    check "Del status" if @city_town_master.del_status
    fill_in "Region", with: @city_town_master.region_id
    fill_in "User", with: @city_town_master.user_id
    click_on "Create City town master"

    assert_text "City town master was successfully created"
    click_on "Back"
  end

  test "updating a City town master" do
    visit city_town_masters_url
    click_on "Edit", match: :first

    check "Active status" if @city_town_master.active_status
    fill_in "City town name", with: @city_town_master.city_town_name
    fill_in "Comment", with: @city_town_master.comment
    check "Del status" if @city_town_master.del_status
    fill_in "Region", with: @city_town_master.region_id
    fill_in "User", with: @city_town_master.user_id
    click_on "Update City town master"

    assert_text "City town master was successfully updated"
    click_on "Back"
  end

  test "destroying a City town master" do
    visit city_town_masters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "City town master was successfully destroyed"
  end
end
