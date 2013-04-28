require 'test_helper'

class HackathonsControllerTest < ActionController::TestCase
  setup do
    @hackathon = hackathons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hackathons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hackathon" do
    assert_difference('Hackathon.count') do
      post :create, hackathon: { desc: @hackathon.desc, end: @hackathon.end, location: @hackathon.location, name: @hackathon.name, scheduleItems: @hackathon.scheduleItems, start: @hackathon.start }
    end

    assert_redirected_to hackathon_path(assigns(:hackathon))
  end

  test "should show hackathon" do
    get :show, id: @hackathon
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hackathon
    assert_response :success
  end

  test "should update hackathon" do
    put :update, id: @hackathon, hackathon: { desc: @hackathon.desc, end: @hackathon.end, location: @hackathon.location, name: @hackathon.name, scheduleItems: @hackathon.scheduleItems, start: @hackathon.start }
    assert_redirected_to hackathon_path(assigns(:hackathon))
  end

  test "should destroy hackathon" do
    assert_difference('Hackathon.count', -1) do
      delete :destroy, id: @hackathon
    end

    assert_redirected_to hackathons_path
  end
end
