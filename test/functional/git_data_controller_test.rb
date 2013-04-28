require 'test_helper'

class GitDataControllerTest < ActionController::TestCase
  setup do
    @git_datum = git_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:git_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create git_datum" do
    assert_difference('GitDatum.count') do
      post :create, git_datum: { repo: @git_datum.repo, time: @git_datum.time, user: @git_datum.user }
    end

    assert_redirected_to git_datum_path(assigns(:git_datum))
  end

  test "should show git_datum" do
    get :show, id: @git_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @git_datum
    assert_response :success
  end

  test "should update git_datum" do
    put :update, id: @git_datum, git_datum: { repo: @git_datum.repo, time: @git_datum.time, user: @git_datum.user }
    assert_redirected_to git_datum_path(assigns(:git_datum))
  end

  test "should destroy git_datum" do
    assert_difference('GitDatum.count', -1) do
      delete :destroy, id: @git_datum
    end

    assert_redirected_to git_data_path
  end
end
