defmodule TextClient.Player do
    alias TextClient.State

    # possible states:
    # initializing, won, lost, good_guess, bad_guess, invalid_move, already_used
    def play(%State{ tally: { game_state: :won } }) do
        exit_with_message("you won")
    end
    
    def play(%State{ tally: { game_state: :lost } }) do
        exit_with_message("you lost")
    end
    
    defp exit_with_message(message) do
        IO.puts(message)

        exit(:normal)
    end
end