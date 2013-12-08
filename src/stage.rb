require './player'
require './enemy'
require './controller'

class Stage
  attr_reader :restart

  def initialize
    @js = Controller.new
    @over = false
    @score = 0
    @bgy = 0
    @restart = false
    
    @player = Player.new
    @enemies = []
    
    @player_shots = []
    @enemy_shots = []
    
    @bg = Gosu::Image.new G.window, 'bg.png'
    @bgh = @bg.height
    
    @music = Gosu::Song.new G.window, 'music.ogg'
    @music.play
    
    @explode_fx = Gosu::Sample.new G.window, 'explode.wav'
    
    @font = Gosu::Font.new G.window, 'droid.ttf', 30
    @font_go = Gosu::Font.new G.window, 'droid.ttf', 60
  end
  
  def update
    @js.update
    if @over
      @restart = true if @js.b2
      return
    end
    
    update_bg
  
    new_enemy?
  
    puts "enemies: #{@enemies.length}" if G::Debug
    puts "life: #{@player.life}" if G::Debug
  
    @player_shots.each do |s|
      s.update
      @player_shots.delete s if s.dead
    end  
  
    puts @player_shots.length if G::Debug
    
    @enemy_shots.each do |s|
      s.update
      @enemy_shots.delete s if s.dead
    end  
  
    puts @enemy_shots.length if G::Debug
    
    @player.update @player_shots, @enemy_shots, @enemies, @js
    
    game_over if @player.life <= 0
    
    @enemies.each do |e|
      e.update @player_shots, @enemy_shots
      @enemies.delete e if e.state == :out
      
      if e.state == :hit
        @enemies.delete e
        @score += 1
        @explode_fx.play
      end
    end
  end
  
  def draw    
    @bg.draw 0, @bgy, 0
    @bg.draw 0, @bgy - @bgh, 0
  
    @player.draw
    
    @enemies.each do |e|
      e.draw
    end
    
    @enemy_shots.each do |s|
      s.draw
    end
    
    @player_shots.each do |s|
      s.draw
    end
    
    @font.draw "Score: #{@score}", 5, 5, 0
    @font.draw "Life: #{@player.life}", 5, 45, 0
    if @over
      @font_go.draw "GAME OVER", 250, 270, 0
      @font.draw "press button 2 to restart", 240, 320, 0
    end
  end
  
  def new_enemy?
    r = rand 100_000
    prob = 1000
    
    x = rand G::ScreenWidth
    y = -(G::ScreenHeight)
    
    @enemies << Enemy.new(x, y, :helicopter) if r < prob
  end
  
  def game_over
    puts "GAME OVER!!" if G::Debug
    puts "Score: #{@score}" if G::Debug 
    @over = true
  end
  
  def update_bg
    @bgy += 1
    @bgy = 0 if @bgy >= @bgh
  end
end
