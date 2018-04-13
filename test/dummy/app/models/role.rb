# frozen_string_literal: true

class Role < ApplicationRecord
  class << Role
    def admin
      Role.new(ActionController::Parameters.new(name: :admin))
    end

    def standard
      Role.new(ActionController::Parameters.new(name: :standard))
    end

    def guest
      Role.new(ActionController::Parameters.new(name: :guest))
    end
  end

  belongs_to :user_role

  def name
    nm = read_attribute(:name)
    nm ? nm.to_sym : nil
  end
end
