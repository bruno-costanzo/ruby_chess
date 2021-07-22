# frozen_string_literal: true

module Database
  def db_save_game
    Dir.mkdir 'saved_games' unless Dir.exist? 'saved_games'
    filename = create_filename
    File.open("saved_games/#{filename}", 'w+') do |file|
      Marshal.dump(self, file)
    end
    puts "Game was saved as \e[36m#{filename}\e[0m"
  rescue SystemCallError => e
    puts "Error while writing to file #{filename}."
    puts e
  end

  def create_filename
    "chess_#{@player_one} vs #{@player_two}"
  end

  def load_game
    file_name = find_saved_file
    File.open("saved_games/#{file_name}") do |file|
      Marshal.load(file)
    end
  end

  def find_saved_file
    saved_games = create_game_list
    if saved_games.empty?
      puts 'There are no saved games to play yet!'
      exit
    else
      print_saved_games(saved_games)
      file_number = select_saved_game(saved_games.size)
      saved_games[file_number.to_i - 1]
      p saved_games[file_number.to_i - 1]
      saved_games[file_number.to_i - 1]
    end
  end

  def print_saved_games(game_list)
    puts "\e[36m[#]\e[0m File Name(s)"
    game_list.each_with_index do |name, index|
      puts "\e[36m[#{index + 1}]\e[0m #{name}"
    end
  end

  def select_saved_game(number)
    file_number = gets.chomp
    return file_number if file_number.to_i.between?(1, number)

    puts 'Input error! Enter a valid file number.'
    select_saved_game(number)
  end

  def create_game_list
    game_list = []
    return game_list unless Dir.exist? 'saved_games'

    Dir.entries('saved_games').each do |name|
      game_list << name if name.match(/(chess)/)
    end
    game_list
  end
end
