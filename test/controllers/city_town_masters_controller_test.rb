require 'test_helper'

class CityTownMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @city_town_master = city_town_masters(:one)
  end

  test "should get index" do
    get city_town_masters_url
    assert_response :success
  end

  test "should get new" do
    get new_city_town_master_url
    assert_response :success
  end

  test "should create city_town_master" do
    assert_difference('CityTownMaster.count') do
      post city_town_masters_url, params: { city_town_master: { active_status: @city_town_master.active_status, city_town_name: @city_town_master.city_town_name, comment: @city_town_master.comment, del_status: @city_town_master.del_status, region_id: @city_town_master.region_id, user_id: @city_town_master.user_id } }
    end

    assert_redirected_to city_town_master_url(CityTownMaster.last)
  end

  test "should show city_town_master" do
    get city_town_master_url(@city_town_master)
    assert_response :success
  end

  test "should get edit" do
    get edit_city_town_master_url(@city_town_master)
    assert_response :success
  end

  test "should update city_town_master" do
    patch city_town_master_url(@city_town_master), params: { city_town_master: { active_status: @city_town_master.active_status, city_town_name: @city_town_master.city_town_name, comment: @city_town_master.comment, del_status: @city_town_master.del_status, region_id: @city_town_master.region_id, user_id: @city_town_master.user_id } }
    assert_redirected_to city_town_master_url(@city_town_master)
  end

  test "should destroy city_town_master" do
    assert_difference('CityTownMaster.count', -1) do
      delete city_town_master_url(@city_town_master)
    end

    assert_redirected_to city_town_masters_url
  end
end
