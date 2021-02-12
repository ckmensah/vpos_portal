require 'test_helper'

class EntityDivMediaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_div_medium = entity_div_media(:one)
  end

  test "should get index" do
    get entity_div_media_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_div_medium_url
    assert_response :success
  end

  test "should create entity_div_medium" do
    assert_difference('EntityDivMedium.count') do
      post entity_div_media_url, params: { entity_div_medium: { active_status: @entity_div_medium.active_status, del_status: @entity_div_medium.del_status, entity_div_code: @entity_div_medium.entity_div_code, media_data: @entity_div_medium.media_data, media_path: @entity_div_medium.media_path, media_type: @entity_div_medium.media_type, user_id: @entity_div_medium.user_id } }
    end

    assert_redirected_to entity_div_medium_url(EntityDivMedium.last)
  end

  test "should show entity_div_medium" do
    get entity_div_medium_url(@entity_div_medium)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_div_medium_url(@entity_div_medium)
    assert_response :success
  end

  test "should update entity_div_medium" do
    patch entity_div_medium_url(@entity_div_medium), params: { entity_div_medium: { active_status: @entity_div_medium.active_status, del_status: @entity_div_medium.del_status, entity_div_code: @entity_div_medium.entity_div_code, media_data: @entity_div_medium.media_data, media_path: @entity_div_medium.media_path, media_type: @entity_div_medium.media_type, user_id: @entity_div_medium.user_id } }
    assert_redirected_to entity_div_medium_url(@entity_div_medium)
  end

  test "should destroy entity_div_medium" do
    assert_difference('EntityDivMedium.count', -1) do
      delete entity_div_medium_url(@entity_div_medium)
    end

    assert_redirected_to entity_div_media_url
  end
end
