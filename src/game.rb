require 'gosu'
require 'joystick'

require './stage'
require './g'

class Game < Gosu::Window
  def initialize
    super G::ScreenWidth, G::ScreenHeight, false
    self.caption = '3 Hour Game'
    G.window = self 
    @stage = Stage.new
  end
  
  def update
    @stage.update    
    @stage = Stage.new if @stage.restart
  end
  
  def draw
    @stage.draw
  end
end

Game.new.show
