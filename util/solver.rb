# frozen_string_literal: true

require 'set'
require_relative './word_list'

class Solver
  attr_reader :constraints

  SEED = 'adieu'

  def initialize
    @contains = {}
    @constraints = Array.new(WordList::WORD_LENGTH)
    @iterations = 0
  end

  def solve
    until list.solved?
      word = guess
      @iterations += 1
      yield(word.upcase).each_with_index do |res, i|
        case res
        when :contains then contains! word[i]
        when :constraint then constraint! i, word[i]
        else excludes! word[i]
        end
      end
    end
  end

  def stats
    { total: list.words.length, iterations: @iterations }
  end

  def init!
    list
  end

  private

  def contains!(chr)
    @contains[chr] = true
    list.filter! { |word| word.include?(chr) }
  end

  def excludes!(chr)
    @contains[chr] = false
    list.filter! { |word| !word.include?(chr) }
  end

  def constraint!(pos, chr)
    @constraints[pos] = chr
    list.filter! { |word| word[pos] == chr }
  end

  def guess
    @iterations.zero? ? SEED : list.next
  end

  def list
    @list ||= WordList.new
  end
end
