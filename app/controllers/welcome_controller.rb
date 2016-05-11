class WelcomeController < ApplicationController

  def show
    @coctailes = Coctaile.all
    @shorts = Coctaile.where("value <= '100'")
    @longs = Coctaile.where("value > '100'")
  end

end