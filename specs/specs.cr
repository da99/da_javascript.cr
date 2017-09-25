
require "../src/da_javascript"
require "spec"

def nodejs(*raw_args)
  output = IO::Memory.new
  error  = IO::Memory.new

  args = ["-e"]
  raw_args.each { |x|
    args.push x
  }

  stat = Process.run("node", args, output: output, error: error)

  if !stat.success? || !error.empty? || !stat.normal_exit? || stat.signal_exit?
    STDERR.puts error.rewind.to_s
    STDERR.puts output.rewind.to_s
    STDERR.puts "Exit code:   #{stat.exit_code}"
    STDERR.puts "Exit signal: #{stat.exit_signal}" if stat.signal_exit?
    Process.exit stat.exit_code
  end

  return output.rewind.to_s.strip
end # === def nodejs

describe "DA_JAVASCRIPT.console_log" do

  it "adds console.log to output" do
    code = DA_JAVASCRIPT.new.code {
      console_log("a", "b", "c")
    }.script.strip

    code.should eq("console.log(\"a\", \"b\", \"c\");")
    nodejs(code).should eq(%[a b c])
  end # === it "ads console.log to output"

end # === desc "DA_JAVASCRIPT.log"

describe ":scope" do

  it "works" do
    code = DA_JAVASCRIPT.new.code {
      result = scope {
        one  = JS_Number.new 1
        zero = JS_Number.new 0
        one + zero
      }
      console_log(result)
    }.script.strip

    nodejs(code).should eq("1")
  end # === it "works"
end # === desc ":scope"


