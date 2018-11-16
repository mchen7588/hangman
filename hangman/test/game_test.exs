defmodule GameTest do
    use ExUnit.Case
    alias Hangman.Game

    test "new_game returns proper structure" do
        game = Game.new_game()

        assert game.turns_left == 7
        assert game.game_state == :initializing
    end
    
    test "game_state does not change for :won or :lost games" do
        for state <- [ :won, :lost ] do
            game = Game.new_game()
                    |> Map.put(:game_state, state)

            assert { ^game, _ } = Game.make_move(game, 1)
        end
    end

    test "first occurrence of letter" do
        game = Game.new_game()
        { game, _tally } = Game.make_move(game, "x")

        assert MapSet.member?(game.used, "x") == true
    end

    test "letter already used" do
        game = Game.new_game()
        { game, _tally } = Game.make_move(game, "x")
        
        assert game.game_state != :already_used

        { game, _tally } = Game.make_move(game, "x")

        assert game.game_state == :already_used
    end

    test "recognize a good guess" do
        game = Game.new_game()
        letter = List.first(game.letters)

        { game, _tally } = Game.make_move(game, letter)

        assert game.game_state == :good_guess
    end

    test "guess the whole word" do
        game = Game.new_game("abc")

        { game, _tally } = Game.make_move(game, "a")
        assert game.game_state == :good_guess
        
        { game, _tally } = Game.make_move(game, "b")
        assert game.game_state == :good_guess
        
        { game, _tally } = Game.make_move(game, "c")

        assert game.game_state == :won
    end

    test "recognize a bad guess" do
        game = Game.new_game("abc")

        { game, _tally } = Game.make_move(game, "d")

        assert game.game_state == :bad_guess
        assert game.turns_left == 6
    end

    test "lose the game" do
        game = Game.new_game("abc")

        { game, _tally } = Game.make_move(game, "d")
        assert game.game_state == :bad_guess
        assert game.turns_left == 6

        { game, _tally } = Game.make_move(game, "e")
        assert game.game_state == :bad_guess
        assert game.turns_left == 5

        { game, _tally } = Game.make_move(game, "f")
        assert game.game_state == :bad_guess
        assert game.turns_left == 4

        { game, _tally } = Game.make_move(game, "g")
        assert game.game_state == :bad_guess
        assert game.turns_left == 3

        { game, _tally } = Game.make_move(game, "h")
        assert game.game_state == :bad_guess
        assert game.turns_left == 2

        { game, _tally } = Game.make_move(game, "i")
        assert game.game_state == :bad_guess
        assert game.turns_left == 1

        { game, _tally } = Game.make_move(game, "j")

        assert game.game_state == :lost
    end
end