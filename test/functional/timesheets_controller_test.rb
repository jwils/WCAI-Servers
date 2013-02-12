require 'test_helper'

class TimesheetsControllerTest < ActionController::TestCase
  setup do
    @timesheet = timesheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timesheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create timesheets" do
    assert_difference('Timesheet.count') do
      post :create, timesheets: { start_date: @timesheet.start_date }
    end

    assert_redirected_to timesheet_path(assigns(:timesheets))
  end

  test "should show timesheets" do
    get :show, id: @timesheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @timesheet
    assert_response :success
  end

  test "should update timesheets" do
    put :update, id: @timesheet, timesheets: { start_date: @timesheet.start_date }
    assert_redirected_to timesheet_path(assigns(:timesheets))
  end

  test "should destroy timesheets" do
    assert_difference('Timesheet.count', -1) do
      delete :destroy, id: @timesheet
    end

    assert_redirected_to timesheets_path
  end
end
