require 'test_helper'

class ActivityFixturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_fixture = activity_fixtures(:one)
  end

  test "should get index" do
    get activity_fixtures_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_fixture_url
    assert_response :success
  end

  test "should create activity_fixture" do
    assert_difference('ActivityFixture.count') do
      post activity_fixtures_url, params: { activity_fixture: { activity_participant_a: @activity_fixture.activity_participant_a, activity_participant_b: @activity_fixture.activity_participant_b, division_code: @activity_fixture.division_code } }
    end

    assert_redirected_to activity_fixture_url(ActivityFixture.last)
  end

  test "should show activity_fixture" do
    get activity_fixture_url(@activity_fixture)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_fixture_url(@activity_fixture)
    assert_response :success
  end

  test "should update activity_fixture" do
    patch activity_fixture_url(@activity_fixture), params: { activity_fixture: { activity_participant_a: @activity_fixture.activity_participant_a, activity_participant_b: @activity_fixture.activity_participant_b, division_code: @activity_fixture.division_code } }
    assert_redirected_to activity_fixture_url(@activity_fixture)
  end

  test "should destroy activity_fixture" do
    assert_difference('ActivityFixture.count', -1) do
      delete activity_fixture_url(@activity_fixture)
    end

    assert_redirected_to activity_fixtures_url
  end
end
