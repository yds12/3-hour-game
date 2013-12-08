class Enemy
  attr_reader :state, :x, :y, :w, :h
  
  def initialize x, y, type
    @counter = 0
    
    @state = :ok
    @x = x
    @y = y
    
    @speedx = 0
    @speedy = 3
    
    @img = Gosu::Image.new G.window, 'enemy.png'
    @w = @img.width
    @h = @img.height
  end
  
  def update pshots, eshots
    @counter += 1
    @x += @speedx
    @y += @speedy
    
    out?
    shot? pshots
        
    eshots << Particle.new(:shot, @x, @y, 0, 5) if @counter % 100 == 0
  end
  
  def draw
    @img.draw @x, @y, 0
  end
  
  def out?
    if @x < -(G::ScreenWidth * 2) || @x > G::ScreenWidth * 3 || 
      @y < -(G::ScreenHeight * 2) || @y > G::ScreenHeight * 3
      @state = :out
    end
  end
  
  def shot? pshots
    pshots.each do |s|
      if G.collide @x, @y, @w, @h, s.x, s.y, s.w, s.h
        @state = :hit
        s.dead = true
        return
      end
    end
  end
end
