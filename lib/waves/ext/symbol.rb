class Symbol

  # Syntactic sugar for using File.join to concatenate the argument to the receiver.
  #
  #   require :lib / :utilities / :string
  #
  # The idea is not original, but we can't remember where we first saw it.

  def / ( s ) ; File.join( self.to_s, s.to_s ) ; end
end
