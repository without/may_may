require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test 'role names are symbols' do
    puts "\n\n\n\n\n\n"
    binding.remote_pry
    ap Role.admin

    puts "\n\n\n\n\n"
    assert_equal :admin, Role.admin.name
  end
end
