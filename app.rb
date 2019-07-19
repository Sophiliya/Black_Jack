require_relative 'black_jack'
require_relative 'terminal_interface'

interface = TerminalInterface.new
game = BlackJack.new(interface)
game.start 
