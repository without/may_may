# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  ActionController::Parameters.permit_all_parameters = true
end
