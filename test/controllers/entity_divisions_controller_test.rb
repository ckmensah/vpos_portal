require 'test_helper'

class EntityDivisionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_division = entity_divisions(:one)
  end

  test "should get index" do
    get entity_divisions_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_division_url
    assert_response :success
  end

  test "should create entity_division" do
    assert_difference('EntityDivision.count') do
      post entity_divisions_url, params: { entity_division: { active_status: @entity_division.active_status, activity_code: @entity_division.activity_code, assigned_code: @entity_division.assigned_code, comment: @entity_division.comment, del_status: @entity_division.del_status, division_name: @entity_division.division_name, entity_code: @entity_division.entity_code, service_label: @entity_division.service_label, suburb_id: @entity_division.suburb_id, user_id: @entity_division.user_id } }
    end

    assert_redirected_to entity_division_url(EntityDivision.last)
  end

  test "should show entity_division" do
    get entity_division_url(@entity_division)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_division_url(@entity_division)
    assert_response :success
  end

  test "should update entity_division" do
    patch entity_division_url(@entity_division), params: { entity_division: { active_status: @entity_division.active_status, activity_code: @entity_division.activity_code, assigned_code: @entity_division.assigned_code, comment: @entity_division.comment, del_status: @entity_division.del_status, division_name: @entity_division.division_name, entity_code: @entity_division.entity_code, service_label: @entity_division.service_label, suburb_id: @entity_division.suburb_id, user_id: @entity_division.user_id } }
    assert_redirected_to entity_division_url(@entity_division)
  end

  test "should destroy entity_division" do
    assert_difference('EntityDivision.count', -1) do
      delete entity_division_url(@entity_division)
    end

    assert_redirected_to entity_divisions_url
  end
end
