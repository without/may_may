class MayMayController < ApplicationController
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
end
