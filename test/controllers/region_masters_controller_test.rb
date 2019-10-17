require 'test_helper'

class RegionMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @region_master = region_masters(:one)
  end

  test "should get index" do
    get region_masters_url
    assert_response :success
  end

  test "should get new" do
    get new_region_master_url
    assert_response :success
  end

  test "should create region_master" do
    assert_difference('RegionMaster.count') do
      post region_masters_url, params: { region_master: { active_status: @region_master.active_status, comment: @region_master.comment, del_status: @region_master.del_status, region_name: @region_master.region_name, user_id: @region_master.user_id } }
    end

    assert_redirected_to region_master_url(RegionMaster.last)
  end

  test "should show region_master" do
    get region_master_url(@region_master)
    assert_response :success
  end

  test "should get edit" do
    get edit_region_master_url(@region_master)
    assert_response :success
  end

  test "should update region_master" do
    patch region_master_url(@region_master), params: { region_master: { active_status: @region_master.active_status, comment: @region_master.comment, del_status: @region_master.del_status, region_name: @region_master.region_name, user_id: @region_master.user_id } }
    assert_redirected_to region_master_url(@region_master)
  end

  test "should destroy region_master" do
    assert_difference('RegionMaster.count', -1) do
      delete region_master_url(@region_master)
    end

    assert_redirected_to region_masters_url
  end
end
