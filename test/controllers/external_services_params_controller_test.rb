require "test_helper"

class ExternalServicesParamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @external_services_param = external_services_params(:one)
  end

  test "should get index" do
    get external_services_params_url
    assert_response :success
  end

  test "should get new" do
    get new_external_services_param_url
    assert_response :success
  end

  test "should create external_services_param" do
    assert_difference("ExternalServicesParam.count") do
      post external_services_params_url, params: { external_services_param: { active_status: @external_services_param.active_status, company_code: @external_services_param.company_code, company_url: @external_services_param.company_url, del_status: @external_services_param.del_status, entity_div_code: @external_services_param.entity_div_code, password: @external_services_param.password, user_id: @external_services_param.user_id, username: @external_services_param.username } }
    end

    assert_redirected_to external_services_param_url(ExternalServicesParam.last)
  end

  test "should show external_services_param" do
    get external_services_param_url(@external_services_param)
    assert_response :success
  end

  test "should get edit" do
    get edit_external_services_param_url(@external_services_param)
    assert_response :success
  end

  test "should update external_services_param" do
    patch external_services_param_url(@external_services_param), params: { external_services_param: { active_status: @external_services_param.active_status, company_code: @external_services_param.company_code, company_url: @external_services_param.company_url, del_status: @external_services_param.del_status, entity_div_code: @external_services_param.entity_div_code, password: @external_services_param.password, user_id: @external_services_param.user_id, username: @external_services_param.username } }
    assert_redirected_to external_services_param_url(@external_services_param)
  end

  test "should destroy external_services_param" do
    assert_difference("ExternalServicesParam.count", -1) do
      delete external_services_param_url(@external_services_param)
    end

    assert_redirected_to external_services_params_url
  end
end
