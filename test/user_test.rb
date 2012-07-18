require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "admin has admin and standard roles" do
    u = User.admin
    assert u.role_names.include?(:admin) && u.role_names.include?(:standard)
  end
end
