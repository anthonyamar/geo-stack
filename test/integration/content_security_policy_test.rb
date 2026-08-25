# frozen_string_literal: true

require "test_helper"

class ContentSecurityPolicyTest < ActionDispatch::IntegrationTest
  test "allows same-origin iframes so letter opener can show mail" do
    get root_path

    csp = response.headers["Content-Security-Policy"]

    assert_includes csp, "frame-ancestors 'self'"
  end
end
