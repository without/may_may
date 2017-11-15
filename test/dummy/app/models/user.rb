# frozen_string_literal: true

class User < ApplicationRecord
  class << User
    def admin
      User.new(ActionController::Parameters.new(:name => 'admin', :roles => [Role.admin, Role.standard]))
    end

    def standard
      User.new(ActionController::Parameters.new(:name => 'standard', :roles => [Role.standard]))
    end

    def guest
      User.new(ActionController::Parameters.new(:name => 'guest', :roles => [Role.guest]))
    end
  end

  has_many :user_roles
  has_many :roles, through: :user_roles

  def role_names
    roles.map(&:name)
  end
end
