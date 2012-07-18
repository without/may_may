require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test 'role names are symbols' do
    assert_equal :admin, Role.admin.name
  end
end
