#!/usr/bin/env ruby

# ReBrace - Corrects opening brace positioning in code.
# Service type: Filter

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

class Rebracer
  def initialize(input)
    @toProcess = input
  end
  
  def rebrace
    needsIndenting = ""
    # Process each of the lines individually
    @toProcess.each_line do |line|
      # Something left over from the last time to indent?
      if needsIndenting != "" then
        # Indent to the same level as the current line
        yield "#{line[/^\s+/]}#{needsIndenting}"
        # And remove the value
        needsIndenting = ""
      end
      # Match against a line starting with whitespace, followed by non-whotespace or a space
      # followed by an opening brace and whitespace
      if line =~ /^(\s*)\S(\S| )*(\{\s+)$/ then
        # We got a match, so remove the brace from the line and insert
        # a new line with the same indentation and a brace.
        newline = line.sub(/\{\s+/, "\n")
        yield newline
        yield "#{line[/^\s+/]}{\n"
      # Comment on the end of the line
      elsif line =~ /^(\s*)\S(\S| )*(\{\s)(\/\/.*)(\s)$/ then
        # We got a match, so remove the brace from the line and insert
        # a new line with the same indentation and a brace.
        newline = line.sub(/\{\s(\/\/.*)(\s)/, "\n")
        yield newline
        yield "#{line[/^\s+/]}{\n"
        needsIndenting =  "#{line[/(\/\/.*)/]}\n"
      else
        # No match, just yield the line again
        yield line
      end
    end
  end
end

# Only run this if called as a script.
if __FILE__ == $0
  input = STDIN.gets nil
  # input now contains the contents of STDIN.

  # print each of the rebraced lines.
  Rebracer.new(input).rebrace { |line| print line }
end