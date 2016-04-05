module DaikuHelper
  def daiku(*args, &block)
    Daiku::Htmlizer.htmlize(self, *args, &block)
  end
end
