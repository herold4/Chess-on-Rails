class GamesController < ApplicationController
  

  def index
    @game = Game.new
    render :index
  end
end
