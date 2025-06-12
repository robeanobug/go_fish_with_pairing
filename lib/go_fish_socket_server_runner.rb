require_relative 'go_fish_socket_server'

server = GoFishSocketServer.new
server.start
loop do
  server.accept_new_client
  server.create_game_if_possible
  # server.run_game(server.lobby) if server.lobby
rescue
  server.stop
end
