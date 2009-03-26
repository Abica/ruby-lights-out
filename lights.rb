class Lights
  attr_accessor :coord, :score
  attr_reader :coord_map
  # clear screen and display quit thing
  def initialize
    @coord = []
    @score = 0
    @coord_map = [*(1..5)]
    self.clear_screen
    self.build_grid
    print "\t\t" + ("=" * 55) + "\n"
    print "\t\t" + "RUBY LIGHTSOUT".center(55) + "\n"
    print "\t\t" + ("=" * 55) + "\n\n\n"
    puts "\t\t(press \"q\" at any time during the game to quit)"
    self.menu(0)
    self.reload
  end

  # setup grid of coords
  def build_grid
    @coord_map.each do |x|
      @coord[x] = []
      @coord_map.each do |y|
        @coord[x][y] = "  "
      end
    end
  end

  # draw grid on screen
  def draw
    print "\t\t Y  1 | 2| 3| 4| 5  \n"
    print "\t\tX\n"
    print "\t\t--  --+--+--+--+--\n"
    print "\t\t1   #{@coord[1][1]}|#{@coord[1][2]}|#{@coord[1][3]}|#{@coord[1][4]}|#{@coord[1][5]}\n"
    print "\t\t--  --+--+--+--+--\n"
    print "\t\t2   #{@coord[2][1]}|#{@coord[2][2]}|#{@coord[2][3]}|#{@coord[2][4]}|#{@coord[2][5]}\n"
    print "\t\t--  --+--+--+--+--\n"
    print "\t\t3   #{@coord[3][1]}|#{@coord[3][2]}|#{@coord[3][3]}|#{@coord[3][4]}|#{@coord[3][5]}\n"
    print "\t\t--  --+--+--+--+--\n"
    print "\t\t4   #{@coord[4][1]}|#{@coord[4][2]}|#{@coord[4][3]}|#{@coord[4][4]}|#{@coord[4][5]}\n"
    print "\t\t--  --+--+--+--+--\n"
  end

  # reset game and randomize lights
  def reload
    @coord_map.each do |x|
      @coord_map.each do |y|
        # get random number and fill grid based on results
        if rand(2).eql?(1)
          @coord[x][y] = "XX"
        else
          @coord[x][y] = "  "
        end
      end
    end
  end


  # perform menu actions
  def menu_select
    print "What would you like to do?\n> "
    choice = gets.chomp
    self.menu(choice)
  end


  # perform menu selections
  def menu(select)
    case select
    # player wants to play game, clear screen and reload grid
    when "1"
      self.clear_screen
      self.reload
      @score = 0
      self.mainloop

    # clear screen and display help file
    when "2"
      self.clear_screen
      print "\n\n\t\t=====================================================\n"
      print "\t\t                        HELP\n"
      print "\t\t=====================================================\n"
      print "\t\tThe main point of this game is to shut off all of the\n"
      print "\t\tlights. Lights that are on are marked by a blank space\n"
      print "\t\tand lights that are turned off are marked by an \"XX\".\n"
      print "\t\tEvery time you specify a light to toggle, that light's\n"
      print "\t\tneighboring 4 rooms will be toggled as well. Try to get\n"
      print "\t\tall of the lights on or off in as few moves as possible.\n"
      print "\t\t~~~~~~~~~~~~~~~~~~~~| Good luck! |~~~~~~~~~~~~~~~~~~~~"
      self.menu(0)
      self.menu_select

    # clear screen and display about author page
    when "3"
      self.clear_screen
      print "\n\n\t\tRuby implementation of LightsOut, by Nicholas Wright.\n\t\t\tOriginal idea unknown.\n"
      self.menu(0)
      self.menu_select

    # allow player to quit game
    when "4", /q/i
      self.clear_screen
      print "\t\tGood bye! Thanks for playing, hope to see you again soon. =)\n\n"
      exit

    # display menu
    else
      self.clear_screen if (select != 0)
      print "\n\n\t\t" + ("=" * 55) + "\n"
      print "\t\t" + "MENU".center(55) + "\n"
      print "\t\t" + ("=" * 55) + "\n"
      print "\t\t1. Play LightsOut\n";
      print "\t\t2. Instructions\n";
      print "\t\t3. About\n";
      print "\t\t4. Quit\n";
      self.menu_select
    end
  end


  # check grid for winner
  def check_grid
    taken = 0
    # run a loop to check x coords in the grid
    @coord_map.each do |x|
      # run another loop to check the y coords in the grid
      @coord_map.each do |y|
        # check if light is on
        if @coord[x][y].eql?("  ")
          taken += 1
        end
      end

      # determine type of winner based on above
      return 1 if taken.eql?(25) # all lights out, stop game
      return 2 if taken.zero? # all lights on, stop game
      return 0
    end
  end


  # toggle light on or off based on the player's input
  def toggle(i, j)
    if @coord[i][j].eql?("  ")
      @coord[i][j] = "XX"
    else
      @coord[i][j] = "  "
    end
  end


  # toggle neighboring lights on or off
  def toggle_neighbors(i, j)
    self.toggle((i - 1), j) if ((i - 1) > 0)
    self.toggle((i + 1), j) if ((i + 1) < 6)
    self.toggle(i, (j - 1)) if ((j - 1) > 0)
    self.toggle(i, (j + 1)) if ((j + 1) < 6)
  end


  # allow player to move
  def move(select)
    self.clear_screen
    if (select =~ /q/i)
      self.menu(4)
    else
      # depending on input, we allow them to move or give an error message
      case select
        # make sure syntax is x,y within required fields
        when /^[1-5],[1-5]$/;
          result = select.split(',')
          self.toggle(result[0].to_i,result[1].to_i)
          self.toggle_neighbors(result[0].to_i, result[1].to_i)
          @score += 1

        # check if input isn't within required fields, display error
        when /^[^1-5],[^1-5]$/;
          print "\nInvalid move, coords must appear on grid.\n\n"

        # user didn't follow x,y syntax, display error
        else;
          print "\nInvalid move, please use x,y syntax to label coords.\n\n"
      end
    end
  end


  # announce winners
  def winner
    if self.check_grid.zero?
      outcome = game.check_grid.eql?(2) ? "on" : "off"
      self.clear_screen
      self.draw
      plural = @score.eql?(1) ? "" : "s";
      print "Congratulations! You managed to turn every light #{outcome} in only #{@score.to_s} move#{plural}!"
      self.menu(0)
    else
      print "Hopefully next time you'll complete the game!\n\n"
    end
  end


  # clear screen to clean up look of game
  def clear_screen
    print (RUBY_PLATFORM !~ /mswin/i) ? `clear` : `cls`
  end


  # mainloop to run game
  def mainloop
    # begin game loop until user decides to quit
    while self.check_grid.zero?
      self.draw
      plural = @score.eql?(1) ? "" : "s"
      print "#{@score.to_s} move#{plural} so far\n"
      print "Which light light do you want to effect? (X,Y)\n> "
      choice = gets.chomp
      self.move(choice)
    end
  end


  # play the game!
  def play
    self.menu(0)
    self.winner
  end
end

# initialize game
game = Lights.new
game.play

