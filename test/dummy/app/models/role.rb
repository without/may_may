class Role < ApplicationRecord
  attr_accessor :name

  belongs_to :user_role

  def name

    nm = read_attribute(:name)
    nm ? nm.to_sym : nil
  end

  def self.admin
    new_unsafe(name: :admin)
  end

  def self.standard
    new_unsafe(name: :standard)
  end

  def self.guest
    new_unsafe(name: :guest)
  end
end
