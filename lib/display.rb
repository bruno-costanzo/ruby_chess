# frozen_string_literal: true

module Display

  def d_welcome_msg
    "Welcome to Chess\n\n"
  end

  def d_invalid_option
    "Invalid option. Please enter '1' to Load Game, '2' for New Game or '3' for Quit"
  end

  def d_menu_options
    "Main Menu\n\t1. Load Game\n\t2. New Game\n\t3. Quit\n"
  end

  def d_user_choice_indicator
    "Option number \u2192 "
  end

  def d_goodbye_msg
    'Thank you for playing Chess. Goodbye!'
  end

  def d_new_game
    "\nNew Game"
  end

  def d_ask_player_name(player_number)
    "\tChoose a name for Player #{player_number}. It must have 4+ characters\n"
  end

  def d_user_name_indicator
    "\u2192 "
  end

  def d_invalid_name
    'Invalid name. It must have 4+ characters. Try again'
  end
end