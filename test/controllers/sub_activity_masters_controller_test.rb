require 'test_helper'

class SubActivityMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_activity_master = sub_activity_masters(:one)
  end

  test "should get index" do
    get sub_activity_masters_url
    assert_response :success
  end

  test "should get new" do
    get new_sub_activity_master_url
    assert_response :success
  end

  test "should create sub_activity_master" do
    assert_difference('SubActivityMaster.count') do
      post sub_activity_masters_url, params: { sub_activity_master: { active_status: @sub_activity_master.active_status, activity_desc: @sub_activity_master.activity_desc, assigned_code: @sub_activity_master.assigned_code, del_status: @sub_activity_master.del_status, user_id: @sub_activity_master.user_id } }
    end

    assert_redirected_to sub_activity_master_url(SubActivityMaster.last)
  end

  test "should show sub_activity_master" do
    get sub_activity_master_url(@sub_activity_master)
    assert_response :success
  end

  test "should get edit" do
    get edit_sub_activity_master_url(@sub_activity_master)
    assert_response :success
  end

  test "should update sub_activity_master" do
    patch sub_activity_master_url(@sub_activity_master), params: { sub_activity_master: { active_status: @sub_activity_master.active_status, activity_desc: @sub_activity_master.activity_desc, assigned_code: @sub_activity_master.assigned_code, del_status: @sub_activity_master.del_status, user_id: @sub_activity_master.user_id } }
    assert_redirected_to sub_activity_master_url(@sub_activity_master)
  end

  test "should destroy sub_activity_master" do
    assert_difference('SubActivityMaster.count', -1) do
      delete sub_activity_master_url(@sub_activity_master)
    end

    assert_redirected_to sub_activity_masters_url
  end
end
