require 'test_helper'

class AssignedServiceCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assigned_service_code = assigned_service_codes(:one)
  end

  test "should get index" do
    get assigned_service_codes_url
    assert_response :success
  end

  test "should get new" do
    get new_assigned_service_code_url
    assert_response :success
  end

  test "should create assigned_service_code" do
    assert_difference('AssignedServiceCode.count') do
      post assigned_service_codes_url, params: { assigned_service_code: { active_status: @assigned_service_code.active_status, comment: @assigned_service_code.comment, del_status: @assigned_service_code.del_status, entity_div_code: @assigned_service_code.entity_div_code, service_code: @assigned_service_code.service_code, user_id: @assigned_service_code.user_id } }
    end

    assert_redirected_to assigned_service_code_url(AssignedServiceCode.last)
  end

  test "should show assigned_service_code" do
    get assigned_service_code_url(@assigned_service_code)
    assert_response :success
  end

  test "should get edit" do
    get edit_assigned_service_code_url(@assigned_service_code)
    assert_response :success
  end

  test "should update assigned_service_code" do
    patch assigned_service_code_url(@assigned_service_code), params: { assigned_service_code: { active_status: @assigned_service_code.active_status, comment: @assigned_service_code.comment, del_status: @assigned_service_code.del_status, entity_div_code: @assigned_service_code.entity_div_code, service_code: @assigned_service_code.service_code, user_id: @assigned_service_code.user_id } }
    assert_redirected_to assigned_service_code_url(@assigned_service_code)
  end

  test "should destroy assigned_service_code" do
    assert_difference('AssignedServiceCode.count', -1) do
      delete assigned_service_code_url(@assigned_service_code)
    end

    assert_redirected_to assigned_service_codes_url
  end
end
