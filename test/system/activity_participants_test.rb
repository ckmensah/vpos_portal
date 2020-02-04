require "application_system_test_case"

class ActivityParticipantsTest < ApplicationSystemTestCase
  setup do
    @activity_participant = activity_participants(:one)
  end

  test "visiting the index" do
    visit activity_participants_url
    assert_selector "h1", text: "Activity Participants"
  end

  test "creating a Activity participant" do
    visit activity_participants_url
    click_on "New Activity Participant"

    check "Active status" if @activity_participant.active_status
    fill_in "Assigned code", with: @activity_participant.assigned_code
    fill_in "Comment", with: @activity_participant.comment
    check "Del status" if @activity_participant.del_status
    fill_in "Division code", with: @activity_participant.division_code
    fill_in "Image data", with: @activity_participant.image_data
    fill_in "Image path", with: @activity_participant.image_path
    fill_in "Participant alias", with: @activity_participant.participant_alias
    fill_in "Participant name", with: @activity_participant.participant_name
    fill_in "User", with: @activity_participant.user_id
    click_on "Create Activity participant"

    assert_text "Activity participant was successfully created"
    click_on "Back"
  end

  test "updating a Activity participant" do
    visit activity_participants_url
    click_on "Edit", match: :first

    check "Active status" if @activity_participant.active_status
    fill_in "Assigned code", with: @activity_participant.assigned_code
    fill_in "Comment", with: @activity_participant.comment
    check "Del status" if @activity_participant.del_status
    fill_in "Division code", with: @activity_participant.division_code
    fill_in "Image data", with: @activity_participant.image_data
    fill_in "Image path", with: @activity_participant.image_path
    fill_in "Participant alias", with: @activity_participant.participant_alias
    fill_in "Participant name", with: @activity_participant.participant_name
    fill_in "User", with: @activity_participant.user_id
    click_on "Update Activity participant"

    assert_text "Activity participant was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity participant" do
    visit activity_participants_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity participant was successfully destroyed"
  end
end
