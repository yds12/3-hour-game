class Particle
  attr_reader :x, :y, :w, :h
  attr_accessor :dead

  def initialize type, x, y, speedx, speedy
    @dead = false
    @x = x
    @y = y
    @speedx = speedx
    @speedy = speedy
    
    @img = Gosu::Image.new G.window, 'particle.png'
    @w = @img.width
    @h = @img.height
  end
  
  def update
    @x += @speedx
    @y += @speedy
    
    out?
  end
  
  def draw
    @img.draw @x, @y, 0
  end
  
  def out?
    if @x + @w < 0 || @x > G::ScreenWidth || @y + @h < 0 || @y > G::ScreenHeight
      @dead = true
    end
  end
end
