# Utility methods mixed into String.
module Waves::Ext::String

  # Syntactic sugar for using File.join to concatenate the argument to the receiver.
  #
  #   require "lib" / "utilities" / "string"
  #
  # The idea is not original, but we can't remember where we first saw it.
  # Waves::Ext::Symbol defines the same method, allowing for :files / 'afilename.txt'
  #
  
  def / ( s ) ; File.join( self, s.to_s ); end
  
  #
  # Originally based on English gem. That code was (a) deprecated,
  # (b) used confusing naming conventions (based on Rails original
  # names, like 'camelize' instead of 'camel_case'), and (c) was
  # not thread-safe (making use of $ variables in gsub).
  #
  # I have dispensed with things like "modulize" since (a) the 
  # meaning of that is sort of vague and (b) it is easy (and
  # considerably clearer) to just use a method chain, like
  # this: module.name.snake_case.fqn2path or (the reverse):
  # path.camel_case.path2fqn
  #
  
  def lowercase ; downcase ; end
  alias_method :lower_case, :lowercase
  def uppercase ; upcase ; end
  alias_method :upper_case, :uppercase
  def titlecase ; gsub( /\b\w/ ) { |x| x.upcase } ; end
  alias_method :title_case, :titlecase
  def fqn2path ; gsub(/::/, '/') ; end
  def basename ; gsub(%r{^.*(::|/)}, '') ; end
  def in_words ; gsub(%r{_|/|::}, ' ') ; end
  def path2fqn ; gsub(%r{/}, '::') ; end

  def snakecase
    gsub( /(^|\W)[A-Z]/) { |x| x.downcase }.
    gsub(/[A-Z]/) { |x| "_#{x.downcase}" }
  end
  alias_method :snake_case, :snakecase

  def camelcase( style = :upper )
    if style == :upper
      gsub( /_\w/ ) { |x| x[1,1].upcase }.gsub(/(^|\W)\w/) { |x| x.upcase }
    else
      gsub( /_\w/ ) { |x| x[1,1].upcase }.gsub(/(^|\W)\w/) { |x| x.downcase }
    end
  end
  alias_method :camel_case, :camelcase

  def ordinal
    gsub(/\d+$/) { |x|
      x = x.to_i
      if (11..13).include?(x % 100)
        "#{i}th"
      else
        case x % 10
        when 1 then "#{x}st"
        when 2 then "#{x}nd"
        when 3 then "#{x}rd"
        else "#{x}th"
        end
      end
    }
  end

end

class String  # :nodoc:
  include Waves::Ext::String
end