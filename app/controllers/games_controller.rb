class GamesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @game ||= Game.new
    render :index
  end
  
  def move
    fail
  end
  
  
  
end
