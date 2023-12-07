require "test_helper"

class EntityDivRefLookupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_div_ref_lookup = entity_div_ref_lookups(:one)
  end

  test "should get index" do
    get entity_div_ref_lookups_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_div_ref_lookup_url
    assert_response :success
  end

  test "should create entity_div_ref_lookup" do
    assert_difference("EntityDivRefLookup.count") do
      post entity_div_ref_lookups_url, params: { entity_div_ref_lookup: { active_status: @entity_div_ref_lookup.active_status, del_status: @entity_div_ref_lookup.del_status, entity_div_code: @entity_div_ref_lookup.entity_div_code, name: @entity_div_ref_lookup.name, pan: @entity_div_ref_lookup.pan, user_id: @entity_div_ref_lookup.user_id } }
    end

    assert_redirected_to entity_div_ref_lookup_url(EntityDivRefLookup.last)
  end

  test "should show entity_div_ref_lookup" do
    get entity_div_ref_lookup_url(@entity_div_ref_lookup)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_div_ref_lookup_url(@entity_div_ref_lookup)
    assert_response :success
  end

  test "should update entity_div_ref_lookup" do
    patch entity_div_ref_lookup_url(@entity_div_ref_lookup), params: { entity_div_ref_lookup: { active_status: @entity_div_ref_lookup.active_status, del_status: @entity_div_ref_lookup.del_status, entity_div_code: @entity_div_ref_lookup.entity_div_code, name: @entity_div_ref_lookup.name, pan: @entity_div_ref_lookup.pan, user_id: @entity_div_ref_lookup.user_id } }
    assert_redirected_to entity_div_ref_lookup_url(@entity_div_ref_lookup)
  end

  test "should destroy entity_div_ref_lookup" do
    assert_difference("EntityDivRefLookup.count", -1) do
      delete entity_div_ref_lookup_url(@entity_div_ref_lookup)
    end

    assert_redirected_to entity_div_ref_lookups_url
  end
end
