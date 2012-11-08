require 'test_helper'

class ProjectFilesControllerTest < ActionController::TestCase
  setup do
    @project_file = project_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_file" do
    assert_difference('ProjectFile.count') do
      post :create, project_file: { file: @project_file.file }
    end

    assert_redirected_to project_file_path(assigns(:project_file))
  end

  test "should show project_file" do
    get :show, id: @project_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_file
    assert_response :success
  end

  test "should update project_file" do
    put :update, id: @project_file, project_file: { file: @project_file.file }
    assert_redirected_to project_file_path(assigns(:project_file))
  end

  test "should destroy project_file" do
    assert_difference('ProjectFile.count', -1) do
      delete :destroy, id: @project_file
    end

    assert_redirected_to project_files_path
  end
end
