# frozen_string_literal: true

require 'thor'
require 'ruby-progressbar'
require 'io/console'
require_relative '../util/solver'

class WordleSolver < Thor
  RESPONSES = {
    'E' => nil,
    'Y' => :contains,
    'G' => :constraint
  }.freeze

  COLORS = {
    'E' => :bold,
    'Y' => :yellow,
    'G' => :green
  }.freeze

  class EarlyExit < Thor::Error; end

  def self.exit_on_failure?
    false
  end

  desc 'solve', 'Interactively solves a wordle puzzle'
  default_task :solve

  def solve
    solve!
  rescue SystemExit, Interrupt
    raise EarlyExit
  end

  private

  def solve!
    puts "Let's do this! Just a little bit of setup first."
    load!

    solver.solve(&method(:handle_word))
    reset

    say
    say 'Congrats!'
  end

  def load!
    progressbar = ProgressBar.create(
      title: set_color('Downloading wordlist', :bold),
      unknown_progress_animation_steps: ['.    ', '..   ', '...  ', '.... ', '.....'],
      total: nil,
      format: '%t%B',
      length: 25,
    )
    Thread.new do
      until progressbar.finished?
        progressbar.increment
        sleep 0.1
      end
    end

    solver.init!

    progressbar.finish
  end

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
    say 'Enter the word above into Wordle, and let me know the color of each cell!'
    say 'E = empty, Y = yellow, G = green'
    say

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
    @defaults ||= Hash.new('E')
  end
end
