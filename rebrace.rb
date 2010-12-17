#!/usr/bin/env ruby

# ThisService Ruby service script example
# Service type: Acts on input.
# Revision 1.

# Unicode considerations:
#  Set $KCODE to 'u'. This makes STDIN and STDOUT both act as containing UTF-8.
$KCODE = 'u'

#  Since any Ruby version before 1.9 doesn't much care for Unicode,
#  patch in a new String#utf8_length method that returns the correct length
#  for UTF-8 strings.
UNICODE_COMPETENT = ((RUBY_VERSION)[0..2].to_f > 1.8)

unless UNICODE_COMPETENT # lower than 1.9
  class String
    def utf8_length
      i = 0
      i = self.scan(/(.)/).length
      i
    end
  end
else # 1.9 and above
  class String
    alias_method :utf8_length, :length
  end
end

input = STDIN.gets nil
# input now contains the contents of STDIN.
# Write your script here.

input.each_line do |line|
  if line =~ /.*\{\s/ then
    newline = line.sub(/\{\s/, "\n")
    print newline
    print "#{line[/^\s+/]}{\n"
  else
    print line
  end
end