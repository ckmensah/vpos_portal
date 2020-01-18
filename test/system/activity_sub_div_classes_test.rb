require "application_system_test_case"

class ActivitySubDivClassesTest < ApplicationSystemTestCase
  setup do
    @activity_sub_div_class = activity_sub_div_classes(:one)
  end

  test "visiting the index" do
    visit activity_sub_div_classes_url
    assert_selector "h1", text: "Activity Sub Div Classes"
  end

  test "creating a Activity sub div class" do
    visit activity_sub_div_classes_url
    click_on "New Activity Sub Div Class"

    check "Active status" if @activity_sub_div_class.active_status
    fill_in "Class desc", with: @activity_sub_div_class.class_desc
    fill_in "Comment", with: @activity_sub_div_class.comment
    check "Del status" if @activity_sub_div_class.del_status
    fill_in "Entity div code", with: @activity_sub_div_class.entity_div_code
    fill_in "User", with: @activity_sub_div_class.user_id
    click_on "Create Activity sub div class"

    assert_text "Activity sub div class was successfully created"
    click_on "Back"
  end

  test "updating a Activity sub div class" do
    visit activity_sub_div_classes_url
    click_on "Edit", match: :first

    check "Active status" if @activity_sub_div_class.active_status
    fill_in "Class desc", with: @activity_sub_div_class.class_desc
    fill_in "Comment", with: @activity_sub_div_class.comment
    check "Del status" if @activity_sub_div_class.del_status
    fill_in "Entity div code", with: @activity_sub_div_class.entity_div_code
    fill_in "User", with: @activity_sub_div_class.user_id
    click_on "Update Activity sub div class"

    assert_text "Activity sub div class was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity sub div class" do
    visit activity_sub_div_classes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity sub div class was successfully destroyed"
  end
end
