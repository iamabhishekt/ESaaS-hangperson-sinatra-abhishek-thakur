class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end
  def word
    @word
  end

  def word=(word)
    @word=word
  end

  def guesses
    @guesses
  end

  def guesses=(guesses)
    @guesses=guesses
  end

  def wrong_guesses
    @wrong_guesses
  end

  def wrong_guesses=(wrong_guesses)
    @wrong_guesses=wrong_guesses
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(letter)

    letter = letter.downcase if(letter != nil)

    raise ArgumentError.new("Not a valid letter") if (letter.nil? or /[^A-Za-z]/.match(letter) != nil or letter == '')

    return false if (@guesses.include? letter or @wrong_guesses.include? letter)

    if @word.include? letter
      @guesses += letter
      true
    else
      @wrong_guesses += letter
      true
    end
  end

  def word_with_guesses
    t=@guesses
    @word.gsub(/[^ #{t}]/, '-')
  end

  def check_win_or_lose
    return :lose if (@wrong_guesses.length >= 7)

    return :win if (word_with_guesses == @word)

    :play
  end
end