require 'test_helper'

class EntityCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_category = entity_categories(:one)
  end

  test "should get index" do
    get entity_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_category_url
    assert_response :success
  end

  test "should create entity_category" do
    assert_difference('EntityCategory.count') do
      post entity_categories_url, params: { entity_category: { active_status: @entity_category.active_status, assigned_code: @entity_category.assigned_code, category_name: @entity_category.category_name, comment: @entity_category.comment, del_status: @entity_category.del_status, user_id: @entity_category.user_id } }
    end

    assert_redirected_to entity_category_url(EntityCategory.last)
  end

  test "should show entity_category" do
    get entity_category_url(@entity_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_category_url(@entity_category)
    assert_response :success
  end

  test "should update entity_category" do
    patch entity_category_url(@entity_category), params: { entity_category: { active_status: @entity_category.active_status, assigned_code: @entity_category.assigned_code, category_name: @entity_category.category_name, comment: @entity_category.comment, del_status: @entity_category.del_status, user_id: @entity_category.user_id } }
    assert_redirected_to entity_category_url(@entity_category)
  end

  test "should destroy entity_category" do
    assert_difference('EntityCategory.count', -1) do
      delete entity_category_url(@entity_category)
    end

    assert_redirected_to entity_categories_url
  end
end
