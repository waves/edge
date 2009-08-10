module Waves
  module Ext
    module Integer
      # @todo: we need to credit where this code came from originally, if anywhere.
      def seconds ; self ; end
      alias_method :second, :seconds
      def minutes ; self * 60 ; end
      alias_method :minute, :minutes
      def hours ; self * 60.minutes ; end
      alias_method :hour, :hours
      def days ; self * 24.hours ; end
      alias_method :day, :days
      def weeks ; self * 7.days ; end
      alias_method :week, :weeks
      def bytes ; self ; end
      alias_method :byte, :bytes
      def kilobytes ; self * 1024 ; end
      alias_method :kilobyte, :kilobytes
      def megabytes ; self * 1024.kilobytes ; end
      alias_method :megabyte, :megabytes
      def gigabytes ; self * 1024.megabytes ; end
      alias_method :gigabyte, :gigabytes
      def terabytes ; self * 1024.gigabytes ; end
      alias_method :terabyte, :terabytes
      def petabytes ; self * 1024.terabytes ; end
      alias_method :petabyte, :petabytes
      def exabytes ; self * 1024.petabytes ; end
      alias_method :exabyte, :exabytes
      def zettabytes ; self * 1024.exabytes ; end
      alias_method :zettabyte, :zettabytes
      def yottabytes ; self * 1024.zettabytes ; end
      alias_method :yottabyte, :yottabytes
      def to_delimited(delim=',')
        self.to_s.gsub(/(\d)(?=(\d\d\d)+$)/, "\\1#{delim}")
      end
    end
  end
end

class Integer 
  include Waves::Ext::Integer
end