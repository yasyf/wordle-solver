# frozen_string_literal: true

require 'thor'
require 'io/console'
require_relative '../util/solver'

class WordleSolver < Thor
  RESPONSES = {
    'e' => nil,
    'y' => :contains,
    'g' => :constraint
  }.freeze

  COLORS = {
    'e' => :bold,
    'y' => :yellow,
    'g' => :green
  }.freeze

  desc 'solve', 'Interactively solves a wordle puzzle'
  default_task :solve

  def solve
    solver.solve(&method(:handle_word))
    reset
    say
    say 'Congrats!'
  end

  private

  def reset
    $stdout.clear_screen

    say_status 'Iteration', solver.stats[:iterations]
    say_status 'Search Space', solver.stats[:total]

    print_board
  end

  def handle_word(word)
    reset
    say_status 'Word', word

    say
    say 'Enter the word, and let me know the color of each block!'

    word.split('').each_with_index.map do |chr, i|
      defaults[i] = ask(
        "#{i + 1}. #{set_color(chr, COLORS[defaults[i]])}",
        limited_to: RESPONSES.keys,
        case_insensitive: true,
        default: defaults[i],
      )
      RESPONSES[defaults[i]]
    end
  end

  def print_board
    board = WordList::WORD_LENGTH.times.map do |i|
      case RESPONSES[defaults[i]]
      when :contains then set_color '[?]', :yellow
      when :constraint then set_color "[#{solver.constraints[i]}]", :green
      else '[?]'
      end
    end.join(' ')
    say_status 'Board', board
  end

  def solver
    @solver ||= Solver.new
  end

  def defaults
    @defaults ||= Hash.new('e')
  end
end
