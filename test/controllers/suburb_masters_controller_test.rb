require 'test_helper'

class SuburbMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @suburb_master = suburb_masters(:one)
  end

  test "should get index" do
    get suburb_masters_url
    assert_response :success
  end

  test "should get new" do
    get new_suburb_master_url
    assert_response :success
  end

  test "should create suburb_master" do
    assert_difference('SuburbMaster.count') do
      post suburb_masters_url, params: { suburb_master: { active_status: @suburb_master.active_status, city_town_id: @suburb_master.city_town_id, comment: @suburb_master.comment, del_status: @suburb_master.del_status, suburb_name: @suburb_master.suburb_name, user_id: @suburb_master.user_id } }
    end

    assert_redirected_to suburb_master_url(SuburbMaster.last)
  end

  test "should show suburb_master" do
    get suburb_master_url(@suburb_master)
    assert_response :success
  end

  test "should get edit" do
    get edit_suburb_master_url(@suburb_master)
    assert_response :success
  end

  test "should update suburb_master" do
    patch suburb_master_url(@suburb_master), params: { suburb_master: { active_status: @suburb_master.active_status, city_town_id: @suburb_master.city_town_id, comment: @suburb_master.comment, del_status: @suburb_master.del_status, suburb_name: @suburb_master.suburb_name, user_id: @suburb_master.user_id } }
    assert_redirected_to suburb_master_url(@suburb_master)
  end

  test "should destroy suburb_master" do
    assert_difference('SuburbMaster.count', -1) do
      delete suburb_master_url(@suburb_master)
    end

    assert_redirected_to suburb_masters_url
  end
end
