require "application_system_test_case"

class ActivityFixturesTest < ApplicationSystemTestCase
  setup do
    @activity_fixture = activity_fixtures(:one)
  end

  test "visiting the index" do
    visit activity_fixtures_url
    assert_selector "h1", text: "Activity Fixtures"
  end

  test "creating a Activity fixture" do
    visit activity_fixtures_url
    click_on "New Activity Fixture"

    fill_in "Activity participant a", with: @activity_fixture.activity_participant_a
    fill_in "Activity participant b", with: @activity_fixture.activity_participant_b
    fill_in "Division code", with: @activity_fixture.division_code
    click_on "Create Activity fixture"

    assert_text "Activity fixture was successfully created"
    click_on "Back"
  end

  test "updating a Activity fixture" do
    visit activity_fixtures_url
    click_on "Edit", match: :first

    fill_in "Activity participant a", with: @activity_fixture.activity_participant_a
    fill_in "Activity participant b", with: @activity_fixture.activity_participant_b
    fill_in "Division code", with: @activity_fixture.division_code
    click_on "Update Activity fixture"

    assert_text "Activity fixture was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity fixture" do
    visit activity_fixtures_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity fixture was successfully destroyed"
  end
end
