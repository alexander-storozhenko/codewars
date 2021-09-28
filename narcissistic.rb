def narcissistic?(value)
  value == value.digits.sum{|digit| digit.to_i ** value.digits.size}
end
