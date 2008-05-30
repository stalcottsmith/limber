
class String
  def varify
    self.slice(0..0).downcase + self.camelcase.slice(1..self.size)
  end
end

