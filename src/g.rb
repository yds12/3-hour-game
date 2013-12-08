class G
  def self.window
    @@window
  end
  
  def self.window= value
    @@window = value
  end
  
  ScreenWidth = 800
  ScreenHeight = 600
  Debug = false
  
  def self.collide x, y, w, h, x1, y1, w1, h1
    x < x1 + w1 && x + w > x1 && y < y1 + h1 && y + h > y1
  end
end
