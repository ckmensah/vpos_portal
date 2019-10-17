require 'test_helper'

class EntityInfoExtrasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_info_extra = entity_info_extras(:one)
  end

  test "should get index" do
    get entity_info_extras_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_info_extra_url
    assert_response :success
  end

  test "should create entity_info_extra" do
    assert_difference('EntityInfoExtra.count') do
      post entity_info_extras_url, params: { entity_info_extra: { active_status: @entity_info_extra.active_status, comment: @entity_info_extra.comment, contact_email: @entity_info_extra.contact_email, contact_number: @entity_info_extra.contact_number, del_status: @entity_info_extra.del_status, entity_code: @entity_info_extra.entity_code, location_address: @entity_info_extra.location_address, postal_address: @entity_info_extra.postal_address, user_id: @entity_info_extra.user_id, web_url: @entity_info_extra.web_url } }
    end

    assert_redirected_to entity_info_extra_url(EntityInfoExtra.last)
  end

  test "should show entity_info_extra" do
    get entity_info_extra_url(@entity_info_extra)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_info_extra_url(@entity_info_extra)
    assert_response :success
  end

  test "should update entity_info_extra" do
    patch entity_info_extra_url(@entity_info_extra), params: { entity_info_extra: { active_status: @entity_info_extra.active_status, comment: @entity_info_extra.comment, contact_email: @entity_info_extra.contact_email, contact_number: @entity_info_extra.contact_number, del_status: @entity_info_extra.del_status, entity_code: @entity_info_extra.entity_code, location_address: @entity_info_extra.location_address, postal_address: @entity_info_extra.postal_address, user_id: @entity_info_extra.user_id, web_url: @entity_info_extra.web_url } }
    assert_redirected_to entity_info_extra_url(@entity_info_extra)
  end

  test "should destroy entity_info_extra" do
    assert_difference('EntityInfoExtra.count', -1) do
      delete entity_info_extra_url(@entity_info_extra)
    end

    assert_redirected_to entity_info_extras_url
  end
end
