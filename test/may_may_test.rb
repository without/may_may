require 'test_helper'

class Roles
  def self.before_filter(*params)
  end

  def self.helper_method(*params)
  end

  include MayMay::MayMayACExtensions
  MayMay::MayMayACExtensions.setup(self)

  attr_accessor :current_roles

  def initialize(roles = [])
    roles = [roles] unless roles.respond_to? :each
    self.current_roles = roles
  end
end

class MayMayTest < ActiveSupport::TestCase
  test "access_denied if not specifically permitted" do
    May.permissions_setup {}
    assert !May.permission_to?(:test_1_action, :people, Roles.new)
  end

  test "access allowed for anyone if named but no roles specified" do
    May.permissions_setup { controller(:people) { may :test_2_action } }
    assert May.permission_to?(:test_2_action, :people, Roles.new)
  end

  test "access allowed for specified role only" do
    May.permissions_setup { controller(:people) { may :test_3_action, :only => :a_role } }
    with_correct_role = May.permission_to?(:test_3_action, :people, Roles.new(:a_role))
    without_correct_role = May.permission_to?(:test_3_action, :people, Roles.new(:b_role))
    assert_equal [true, false], [with_correct_role, without_correct_role]
  end

  test "access allowed for specified roles" do
    May.permissions_setup { controller(:people) { may :test_4_action, :only => [:a_role1, :a_role2] } }
    with_first_role = May.permission_to?(:test_4_action, :people, Roles.new(:a_role1))
    with_second_role = May.permission_to?(:test_4_action, :people, Roles.new(:a_role2))
    with_both_roles = May.permission_to?(:test_4_action, :people, Roles.new([:a_role1, :a_role2]))
    with_neither_role = May.permission_to?(:test_4_action, :people, Roles.new(:b_role))
    assert_equal [true, true, true, false], [with_first_role, with_second_role, with_both_roles, with_neither_role]
  end

  test "access denied for specified roles" do
    May.permissions_setup { controller(:people) { may :test_5_action, :except => [:a_role1, :a_role2] } }
    with_first_role = May.permission_to?(:test_5_action, :people, Roles.new(:a_role1))
    with_second_role = May.permission_to?(:test_5_action, :people, Roles.new(:a_role2))
    with_both_roles = May.permission_to?(:test_5_action, :people, Roles.new([:a_role1, :a_role2]))
    with_neither_role = May.permission_to?(:test_5_action, :people, Roles.new(:b_role))
    assert_equal [false, false, false, true], [with_first_role, with_second_role, with_both_roles, with_neither_role]
  end

  test "access denied by block" do
    May.permissions_setup { controller(:people) { may(:test_6_action) {|controller| false } } }
    assert !May.permission_to?(:test_6_action, :people, Roles.new)
  end

  test "access allowed by block" do
    May.permissions_setup { controller(:people) { may(:test_7_action) {|controller| true } } }
    assert May.permission_to?(:test_7_action, :people, Roles.new)
  end

  test "controller may method works" do
    May.permissions_setup { controller(:people) { may(:test_8_action, :only => [:a_role]) } }
    with_role = Roles.new(:a_role).may?(:test_8_action, :people)
    without_role = Roles.new.may?(:test_8_action, :people)
    assert_equal [true, false], [with_role, without_role]
  end

  test "controller may method with block" do
    May.permissions_setup { controller(:people) { may(:test_9_action, :only => [:a_role]) } }
    with_role = false
    Roles.new(:a_role).may?(:test_9_action, :people) { with_role = 'allowed!' }
    without_role = Roles.new.may?(:test_9_action, :people) { without_role = 'not allowed!' }
    assert_equal ['allowed!', false], [with_role, without_role]
  end

  test "controller may with permission block" do
    can = true
    May.permissions_setup {controller(:people) { may(:test_10_action) { can } } }
    should = false
    Roles.new.may?(:test_10_action, :people) { should = 'allowed!' }
    can = false
    should_not = false
    should_not = Roles.new.may?(:test_10_action, :people) { should_not = 'not allowed!' }
    assert_equal ['allowed!', false], [should, should_not]
  end
end
