defmodule TextClient.Player do
    alias TextClient.State

    # possible states:
    # initializing, won, lost, good_guess, bad_guess, invalid_move, already_used

    def play(game = %State{ tally: %{ game_state: :good_guess } }) do
        continue_with_message(game, "good guess")
    end

    def play(game = %State{ tally: %{ game_state: :bad_guess } }) do
        continue_with_message(game, "bad guess")
    end

    def play(game = %State{ tally: %{ game_state: :invalid_move } }) do
        continue_with_message(game, "invalid move")
    end

    def play(game = %State{ tally: %{ game_state: :already_used } }) do
        continue_with_message(game, "already used")
    end
    
    def play(%State{ tally: %{ game_state: :won } }) do
        exit_with_message("you won")
    end
    
    def play(%State{ tally: %{ game_state: :lost } }) do
        exit_with_message("you lost")
    end

    def play(game) do
        continue(game)
    end

    defp continue_with_message(game, message) do
        IO.puts(message)

        continue(game)
    end

    defp continue(game) do
        game
            |> display()
            |> prompt()
            |> IO.inspect()
            |> make_move()
            |> play()
    end

    defp display(game = %State{ tally: tally }) do
        IO.puts [
            "\n",
            "game progress: #{Enum.join(tally.letters, " ")}",
            "\n",
            "guesses left: #{tally.turns_left}",
            "\n"
        ]

        game
    end

    defp prompt(game) do
        IO.gets("your guess: ")
            |> String.trim()
            |> check_input(game)

    end

    defp check_input({ :error, reason }, _) do
        IO.puts("game crashed: #{reason}")
    end

    defp check_input(:eof, _) do
        IO.puts("game crashed")
    end

    defp check_input(input, game) do
        validator = :is_valid
            |> validate(is_single_lowercase_letter?(input))

        accept_input(input, game, validator)
    end

    defp is_single_lowercase_letter?(string) do
        string =~ ~r/\A[a-zA-Z]\z/
    end

    defp validate(_validity = :is_valid, _is_valid? = true) do
        :is_valid
    end

    defp validate(_validity = :is_valid, _is_valid? = false) do
        :not_valid
    end

    defp validate(validity = _not_valid, _is_valid) do
        validity
    end

    defp accept_input(input, game, :is_valid) do
        Map.put(game, :guess, String.downcase(input))
    end

    defp accept_input(_input, game, _is_valid) do
        IO.puts("please enter a valid letter")

        prompt(game)
    end

    defp make_move(game) do
        game
    end
    
    defp exit_with_message(message) do
        IO.puts(message)

        exit(:normal)
    end
end