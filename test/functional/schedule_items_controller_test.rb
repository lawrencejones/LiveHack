require 'test_helper'

class ScheduleItemsControllerTest < ActionController::TestCase
  setup do
    @schedule_item = schedule_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:schedule_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create schedule_item" do
    assert_difference('ScheduleItem.count') do
      post :create, schedule_item: { iconUrl: @schedule_item.iconUrl, isMajor: @schedule_item.isMajor, name: @schedule_item.name, time: @schedule_item.time }
    end

    assert_redirected_to schedule_item_path(assigns(:schedule_item))
  end

  test "should show schedule_item" do
    get :show, id: @schedule_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @schedule_item
    assert_response :success
  end

  test "should update schedule_item" do
    put :update, id: @schedule_item, schedule_item: { iconUrl: @schedule_item.iconUrl, isMajor: @schedule_item.isMajor, name: @schedule_item.name, time: @schedule_item.time }
    assert_redirected_to schedule_item_path(assigns(:schedule_item))
  end

  test "should destroy schedule_item" do
    assert_difference('ScheduleItem.count', -1) do
      delete :destroy, id: @schedule_item
    end

    assert_redirected_to schedule_items_path
  end
end
