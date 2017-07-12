class MayMaysController < ApplicationController
  may :create, method: :can_create?
  may :extra, only: %i[stanard admin], method: :current_user

  def index
    render plain: 'index'
  end

  def new
    render layout: false
  end

  def show
    render plain: 'show'
  end

  def destroy
    render plain: 'destroy'
  end

  def create
    render plain: 'create'
  end

  def can_create?
    current_user.name == 'admin'
  end

  def extra
    render plain: 'extra!'
  end
end
