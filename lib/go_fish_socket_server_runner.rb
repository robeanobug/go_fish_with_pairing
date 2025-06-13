require_relative 'go_fish_socket_server'

server = GoFishSocketServer.new
server.start
loop do
  server.accept_new_client
  server.get_player_name
  game = server.create_game_if_possible
  server.run_game(game) if game
rescue
  server.stop
end
