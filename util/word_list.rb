# frozen_string_literal: true

require 'open-uri'

class WordList
  DEFAULT_REPO = 'IlyaSemenov/wikipedia-word-frequency'
  DEFAULT_FILE = 'master/results/enwiki-20190320-words-frequency.txt'
  WORD_LENGTH  = 5

  class UnsolvablePuzzleError < Thor::Error; end

  attr_reader :words

  def initialize(repo = DEFAULT_REPO, file = DEFAULT_FILE)
    @url = "https://raw.githubusercontent.com/#{repo}/#{file}"
    fetch_words!
  end

  def filter!(&block)
    words.select!(&block)
  end

  def next
    words.first.first
  end

  def solved?
    raise UnsolvablePuzzleError if words.empty?

    words.length == 1
  end

  private

  def fetch_words!
    @words ||= URI.open(@url).read.split("\n").each_with_object({}) do |line, words|
      word, count = line.split(' ')
      words[word] = count.to_i if word.length == WORD_LENGTH
    end
  end
end
