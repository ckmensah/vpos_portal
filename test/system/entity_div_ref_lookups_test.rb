require "application_system_test_case"

class EntityDivRefLookupsTest < ApplicationSystemTestCase
  setup do
    @entity_div_ref_lookup = entity_div_ref_lookups(:one)
  end

  test "visiting the index" do
    visit entity_div_ref_lookups_url
    assert_selector "h1", text: "Entity div ref lookups"
  end

  test "should create entity div ref lookup" do
    visit entity_div_ref_lookups_url
    click_on "New entity div ref lookup"

    check "Active status" if @entity_div_ref_lookup.active_status
    check "Del status" if @entity_div_ref_lookup.del_status
    fill_in "Entity div code", with: @entity_div_ref_lookup.entity_div_code
    fill_in "Name", with: @entity_div_ref_lookup.name
    fill_in "Pan", with: @entity_div_ref_lookup.pan
    fill_in "User", with: @entity_div_ref_lookup.user_id
    click_on "Create Entity div ref lookup"

    assert_text "Entity div ref lookup was successfully created"
    click_on "Back"
  end

  test "should update Entity div ref lookup" do
    visit entity_div_ref_lookup_url(@entity_div_ref_lookup)
    click_on "Edit this entity div ref lookup", match: :first

    check "Active status" if @entity_div_ref_lookup.active_status
    check "Del status" if @entity_div_ref_lookup.del_status
    fill_in "Entity div code", with: @entity_div_ref_lookup.entity_div_code
    fill_in "Name", with: @entity_div_ref_lookup.name
    fill_in "Pan", with: @entity_div_ref_lookup.pan
    fill_in "User", with: @entity_div_ref_lookup.user_id
    click_on "Update Entity div ref lookup"

    assert_text "Entity div ref lookup was successfully updated"
    click_on "Back"
  end

  test "should destroy Entity div ref lookup" do
    visit entity_div_ref_lookup_url(@entity_div_ref_lookup)
    click_on "Destroy this entity div ref lookup", match: :first

    assert_text "Entity div ref lookup was successfully destroyed"
  end
end
