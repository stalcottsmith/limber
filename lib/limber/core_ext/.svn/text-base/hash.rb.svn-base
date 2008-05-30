
class Hash
  def to_action_script(indent='')
    longest_key_length = self.keys.inject(0) {|max_len, key| max_len > key.to_s.varify.length ? max_len : key.to_s.varify.length}
    "{#{self.to_a.collect {|k,v| k.to_s.varify+':'+' '*(longest_key_length - k.to_s.varify.length)+v.to_s}.join(",\n#{indent}")}}"
  end
end

