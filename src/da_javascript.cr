
class DA_JAVASCRIPT

  @parent = DA_JAVASCRIPT

  def initialize
    @script = IO::Memory.new
    @parent = nil
  end # === def initialize

  def code
    with self yield
    self
  end # === def code

  def scope
    new_scope = DA_JAVASCRIPT.new
    with new_scope yield
    self
  end # === def scope

  def console_log(*args)
    @script << "\n"
    @script << "console.log("
    @script << args.map { |x| x.inspect }.join(", ")
    @script << ");"
  end # === def console_log

  def script
    @script.to_s
  end # === def output

end # === class DA_JAVASCRIPT
