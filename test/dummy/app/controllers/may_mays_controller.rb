class MayMaysController < ApplicationController
  may :create, method: :can_create?

  def index
    render text: 'index'
  end

  def new
    render layout: false
  end

  def show
    render text: 'show'
  end

  def destroy
    render text: 'destroy'
  end

  def create
    render text: 'create'
  end

  def can_create?
    current_user.name == 'admin'
  end
end
