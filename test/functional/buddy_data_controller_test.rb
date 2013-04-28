require 'test_helper'

class BuddyDataControllerTest < ActionController::TestCase
  setup do
    @buddy_datum = buddy_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buddy_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create buddy_datum" do
    assert_difference('BuddyDatum.count') do
      post :create, buddy_datum: { idea: @buddy_datum.idea, isIdea: @buddy_datum.isIdea, name: @buddy_datum.name, skills: @buddy_datum.skills }
    end

    assert_redirected_to buddy_datum_path(assigns(:buddy_datum))
  end

  test "should show buddy_datum" do
    get :show, id: @buddy_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @buddy_datum
    assert_response :success
  end

  test "should update buddy_datum" do
    put :update, id: @buddy_datum, buddy_datum: { idea: @buddy_datum.idea, isIdea: @buddy_datum.isIdea, name: @buddy_datum.name, skills: @buddy_datum.skills }
    assert_redirected_to buddy_datum_path(assigns(:buddy_datum))
  end

  test "should destroy buddy_datum" do
    assert_difference('BuddyDatum.count', -1) do
      delete :destroy, id: @buddy_datum
    end

    assert_redirected_to buddy_data_path
  end
end
