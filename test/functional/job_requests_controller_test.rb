require 'test_helper'

class JobRequestsControllerTest < ActionController::TestCase
  setup do
    @job_request = job_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_request" do
    assert_difference('JobRequest.count') do
      post :create, job_request: { description: @job_request.description, priority: @job_request.priority }
    end

    assert_redirected_to job_request_path(assigns(:job_request))
  end

  test "should show job_request" do
    get :show, id: @job_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_request
    assert_response :success
  end

  test "should update job_request" do
    put :update, id: @job_request, job_request: { description: @job_request.description, priority: @job_request.priority }
    assert_redirected_to job_request_path(assigns(:job_request))
  end

  test "should destroy job_request" do
    assert_difference('JobRequest.count', -1) do
      delete :destroy, id: @job_request
    end

    assert_redirected_to job_requests_path
  end
end
