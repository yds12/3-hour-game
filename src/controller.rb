class Controller
  attr_reader :up, :down, :left, :right, :b1, :b2
  
  def initialize
    @up = false
    @down = false
    @left = false
    @right = false
    @b1 = false
    @b2 = false
  
    @js = Joystick::Device.new "/dev/input/js0"
    
    raise 'Joystick not connected!!!' unless @js
    
    e = @js.event(true)
    e = @js.event(true) while e
  end
  
  def update
    e = @js.event(true)
    
    while e
      if e.type == :axis
      
        if e.number == 0
          @left = false
          @right = false
          
          if e.value < 0
            @left = true
            puts 'left' if G::Debug
          elsif e.value > 0
            @right = true
            puts 'right' if G::Debug
          end
        end
        
        if e.number == 1
          @up = false
          @down = false
          
          if e.value < 0
            @up = true
            puts 'up' if G::Debug
          elsif e.value > 0
            @down = true
            puts 'down' if G::Debug
          end
        end
        
      elsif e.type == :button
      
        if e.number == 2
          @b1 = false
          if e.value > 0
            @b1 = true
          end
        elsif e.number == 1
          @b2 = false
          if e.value > 0
            @b2 = true
          end
        end
        
      end     
    
      e = @js.event(true)
    end
  end
end
