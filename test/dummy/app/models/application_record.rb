class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def new_unsafe(params)
    n = self.new
    params.each { |k,v| n.send("#{k}=", v) }
    yield(n) if block_given?
    n
  end
end
