class User < ActiveRecord::Base
  attr_accessible :name, :roles

  has_many :user_roles
  has_many :roles, through: :user_roles

  def role_names
    roles.map(&:name)
  end

  def self.admin
    new(:name => 'admin', :roles => [Role.admin, Role.standard])
  end

  def self.standard
    new(:name => 'standard', :roles => [Role.standard])
  end

  def self.guest
    new(:name => 'guest', :roles => [Role.guest])
  end
end
