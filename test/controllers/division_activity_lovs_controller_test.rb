require 'test_helper'

class DivisionActivityLovsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @division_activity_lov = division_activity_lovs(:one)
  end

  test "should get index" do
    get division_activity_lovs_url
    assert_response :success
  end

  test "should get new" do
    get new_division_activity_lov_url
    assert_response :success
  end

  test "should create division_activity_lov" do
    assert_difference('DivisionActivityLov.count') do
      post division_activity_lovs_url, params: { division_activity_lov: { active_status: @division_activity_lov.active_status, activity_code: @division_activity_lov.activity_code, comment: @division_activity_lov.comment, del_status: @division_activity_lov.del_status, division_code: @division_activity_lov.division_code, lov_desc: @division_activity_lov.lov_desc, user_id: @division_activity_lov.user_id } }
    end

    assert_redirected_to division_activity_lov_url(DivisionActivityLov.last)
  end

  test "should show division_activity_lov" do
    get division_activity_lov_url(@division_activity_lov)
    assert_response :success
  end

  test "should get edit" do
    get edit_division_activity_lov_url(@division_activity_lov)
    assert_response :success
  end

  test "should update division_activity_lov" do
    patch division_activity_lov_url(@division_activity_lov), params: { division_activity_lov: { active_status: @division_activity_lov.active_status, activity_code: @division_activity_lov.activity_code, comment: @division_activity_lov.comment, del_status: @division_activity_lov.del_status, division_code: @division_activity_lov.division_code, lov_desc: @division_activity_lov.lov_desc, user_id: @division_activity_lov.user_id } }
    assert_redirected_to division_activity_lov_url(@division_activity_lov)
  end

  test "should destroy division_activity_lov" do
    assert_difference('DivisionActivityLov.count', -1) do
      delete division_activity_lov_url(@division_activity_lov)
    end

    assert_redirected_to division_activity_lovs_url
  end
end
