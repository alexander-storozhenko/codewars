# frozen_string_literal: true
require 'colorize'

def string_to_bits_array(string)
  string.unpack1('B*').chars.map(&:to_i).take(16)
end

def control_positions(len)
  positions = [1]
  value = 0

  loop { (pos = 2 ** (value += 1)) <= len ? positions << pos : break }

  positions
end

def get_step_range(array, pos)
  index = pos - 1
  res = []
  array_size = array.size

  loop { res << array[index..(index + pos - 1)]; break if (index += pos * 2) >= array_size }

  res
end

def find_control_bit_value(array)
  array.flatten.sum.even? ? 0 : 1
end

def insert_init_control_bits_values(array, positions)
  positions.each { |pos| array.insert(pos - 1, 0) }
end

def init_control_bits_values(array, positions)

  positions.each do |pos|
    step_range = get_step_range(array, pos)
    array[pos - 1] = find_control_bit_value(step_range)
  end

  array
end

def reset_control_bits_values(array, positions)
  positions.each { |pos| array[pos - 1] = 0 }
end

def find_error_bit_index(array, err_array)
  array.map.with_index { |bit, index| index + 1 unless bit == err_array[index] }.reject(&:nil?).sum - 1
end

def remove_control_bits(array, positions)
  array.select.with_index { |_, index| !positions.include?(index + 1) }
end

# ----------------------------------------------------------------

def encode(msg)
  positions = control_positions(msg.size)

  insert_init_control_bits_values(msg, positions)
  init_control_bits_values(msg, positions)
end

def decode(msg)
  original = msg.dup
  positions = control_positions(msg.size)

  reset_control_bits_values(msg, positions)
  init_control_bits_values(msg, positions)

  error_index = find_error_bit_index(msg, original)

  unless error_index == -1
    msg[error_index] = msg[error_index].zero? ? 1 : 0

    reset_control_bits_values(msg, positions)
    init_control_bits_values(msg, positions)
  end

  remove_control_bits(msg, positions)
end