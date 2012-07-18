class Role < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user_role

  def name
    nm = read_attribute(:name)
    nm ? nm.to_sym : nil
  end

  def self.admin
    new(name: :admin)
  end

  def self.standard
    new(name: :standard)
  end

  def self.guest
    new(name: :guest)
  end
end
