# frozen_string_literal: true

require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should render 404 page" do
    get "/404"
    assert_response :success
  end

  test "should render 422 page" do
    get "/422"
    assert_response :success
  end

  test "should render 500 page" do
    get "/500"
    assert_response :success
  end
end
