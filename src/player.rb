require './particle'

class Player
  attr_reader :life

  def initialize
    @draw_hit = false
    @invulnerable = false
    @life = 10
    @img = Gosu::Image.new G.window, 'player.png'    
    @w = @img.width
    @h = @img.height
    @x = G::ScreenWidth / 2 - @w / 2
    @y = G::ScreenHeight - @h
    @speed = 5
    
    @explode_fx = Gosu::Sample.new G.window, 'explode.wav'
    @shot_fx = Gosu::Sample.new G.window, 'shot.wav'
  end
  
  def update pshots, eshots, enemies, js
    if @invulnerable
      @inv_count -= 1
      
      @invulnerable = false if @inv_count == 0
    end
  
    hit? eshots, enemies
    
    if js.left
      @x -= @speed
      @x = 0 if @x < 0
    elsif js.right
      @x += @speed
      @x = G::ScreenWidth - @w if @x > G::ScreenWidth - @w
    end
    
    if js.up
      @y -= @speed
      @y = 0 if @y < 0
    elsif js.down
      @y += @speed
      @y = G::ScreenHeight - @h if @y > G::ScreenHeight - @h
    end
    
    if js.b1
      pshots << Particle.new(:shot, @x, @y, 0, -20)
      @shot_fx.play
    end
  end
  
  def draw
    @img.draw @x, @y, 0
    
    if @draw_hit      
      G.window.draw_quad 0, 0, 0xffff0000,
        G::ScreenWidth, 0, 0xffff0000,
        G::ScreenWidth, G::ScreenHeight, 0xffff0000,
        0, G::ScreenHeight, 0xffff0000
      
      @draw_hit = false
    end
  end
  
  def hit? eshots, enemies
    eshots.each do |p|
      if G.collide @x, @y, @w, @h, p.x, p.y, p.w, p.h
        hit
        p.dead = true
        return
      end
    end
    
    enemies.each do |p|
      if G.collide @x, @y, @w, @h, p.x, p.y, p.w, p.h
        hit
        return
      end
    end
  end
  
  def hit
    unless @invulnerable
      @life -= 1
      @invulnerable = true
      @inv_count = 30
      @draw_hit = true
      
      @explode_fx.play
    end
  end
end
