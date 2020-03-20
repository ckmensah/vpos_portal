require "application_system_test_case"

class EntityDivSubActivitiesTest < ApplicationSystemTestCase
  setup do
    @entity_div_sub_activity = entity_div_sub_activities(:one)
  end

  test "visiting the index" do
    visit entity_div_sub_activities_url
    assert_selector "h1", text: "Entity Div Sub Activities"
  end

  test "creating a Entity div sub activity" do
    visit entity_div_sub_activities_url
    click_on "New Entity Div Sub Activity"

    check "Active status" if @entity_div_sub_activity.active_status
    check "Del status" if @entity_div_sub_activity.del_status
    fill_in "Div sub activity desc", with: @entity_div_sub_activity.div_sub_activity_desc
    fill_in "Entity div code", with: @entity_div_sub_activity.entity_div_code
    fill_in "Sub activity code", with: @entity_div_sub_activity.sub_activity_code
    fill_in "User", with: @entity_div_sub_activity.user_id
    click_on "Create Entity div sub activity"

    assert_text "Entity div sub activity was successfully created"
    click_on "Back"
  end

  test "updating a Entity div sub activity" do
    visit entity_div_sub_activities_url
    click_on "Edit", match: :first

    check "Active status" if @entity_div_sub_activity.active_status
    check "Del status" if @entity_div_sub_activity.del_status
    fill_in "Div sub activity desc", with: @entity_div_sub_activity.div_sub_activity_desc
    fill_in "Entity div code", with: @entity_div_sub_activity.entity_div_code
    fill_in "Sub activity code", with: @entity_div_sub_activity.sub_activity_code
    fill_in "User", with: @entity_div_sub_activity.user_id
    click_on "Update Entity div sub activity"

    assert_text "Entity div sub activity was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity div sub activity" do
    visit entity_div_sub_activities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity div sub activity was successfully destroyed"
  end
end
