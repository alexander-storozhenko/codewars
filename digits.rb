def digits(input)
    num1 = "32341"
    arr = num1.split('').map(&:to_i)
    count = arr.count
    to_take = count.even? ? (count - 2) / 2 : (count - 1) / 2
    
    arr.first(to_take).sum == arr.last(to_take).sum 
end