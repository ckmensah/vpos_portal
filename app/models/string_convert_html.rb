class StringConvertHtml
  def initialize(str, highlight_hsh)
    @str = str
    @highlight_hsh = highlight_hsh
  end


  def to_html
    chunk_str_arr = @str.split(" ")
    puts "==========================="
    puts "Chunk Array"
    puts chunk_str_arr.inspect
    @highlight_hsh.each do |hsh|
      i = chunk_str_arr.index(hsh[:start])
      if i
        chunk_str_arr[i] = "<b>#{i}"
        puts chunk_str_arr[i].inspect
      end

      puts "Start ======== #{hsh[:start].inspect}"
      puts "End ======== #{hsh[:end].inspect}"
      j = chunk_str_arr.index(hsh[:end] - 1)
      if j
        chunk_str_arr[j] = "#{j}</b>"
      end
    end

    puts "==========================="
    puts "Chunk Array Updated ...."
    puts chunk_str_arr.inspect

    newline_split = @str.split("\n\n")
    puts newline_split[0]
    puts "==================="
    puts "==================="
    newline_split.each do |paragraph|
      p_str = "<p>#{paragraph}</p>"
      p_html_str = p_str
    end
  end

end
#highlight_hsh = []
#highlight_hsh = [{
#                  start: 20,
#                  end: 35,
#                  comment: 'Foo'
#              }, {
#                  start: 73,
#                  end: 92,
#                  comment: 'Bar'
#              }, {
#                  start: 50,
#                  end: 98,
#                  comment: 'Baz'
#              }]
##str = ""
#str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas consectetur malesuada velit, sit amet porta magna maximus nec. Aliquam aliquet tincidunt enim vel rutrum. Ut augue lorem, rutrum et turpis in, molestie mollis nisi. Ut dapibus erat eget felis pulvinar, ac vestibulum augue bibendum. Quisque sagittis magna nisi. Sed aliquam porttitor fermentum. Nulla consequat justo eu nulla sollicitudin auctor. Sed porta enim non diam mollis, a ullamcorper dolor molestie. Nam eu ex non nisl viverra hendrerit. Donec ante augue, eleifend vel eleifend quis, laoreet volutpat ipsum. Integer viverra aliquam nulla, ac rutrum dui sodales nec.
#
#Sed turpis enim, porttitor nec maximus sed, luctus pretium elit. Sed sodales imperdiet velit, vitae viverra erat commodo non. Nunc porttitor risus sit amet quam faucibus, et luctus ex fringilla. Mauris quis urna non lacus tempor iaculis vitae quis dolor. Nam vitae pulvinar lacus, quis varius erat. Etiam lobortis orci vitae elementum tempor. Praesent convallis euismod enim vel vestibulum. Proin vitae eros vitae nisi cursus dapibus vitae at ipsum. Phasellus sed tempor eros, non scelerisque nunc. Nullam condimentum ex ultrices, ultrices ante sit amet, rhoncus nibh. Aliquam fermentum vulputate fringilla. Ut risus orci, pharetra eu tellus vel, fringilla feugiat dolor.
#
#Nunc quis elit quam. Sed aliquet, nibh ut sagittis egestas, lorem tortor laoreet diam, non maximus lectus dolor dignissim eros. Sed vehicula mi id aliquet aliquam. Vestibulum sed lacus et neque dictum convallis in vitae mauris. Etiam varius augue vel mattis tempor. Curabitur mattis facilisis metus, tempus consectetur quam aliquam sed. Mauris velit orci, efficitur sit amet nisl in, finibus dictum elit. In lectus augue, elementum eu sapien sed, auctor tincidunt urna.
#
#Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Integer lacinia accumsan velit. Duis vel facilisis libero. Cras consequat sit amet mauris ut ultrices. Ut pulvinar sit amet odio sit amet pretium. Nullam tortor ligula, consequat non nisl vitae, rutrum placerat est. Sed finibus interdum justo vel placerat. Cras varius tortor sed justo tempus scelerisque. Praesent facilisis ex vitae iaculis iaculis. Sed consectetur a lectus non condimentum. Etiam id lacus a nulla cursus laoreet. Vivamus ipsum purus, sodales vel metus varius, viverra mollis justo. Nulla facilisi. Vivamus volutpat nunc elit, quis sollicitudin velit ornare sit amet.
#
#Nullam fringilla nisi nunc, vitae accumsan tortor luctus quis. Sed facilisis, est ut eleifend sagittis, felis dolor pellentesque lectus, in congue purus orci non nunc. Nunc finibus eu metus et volutpat. Integer hendrerit tortor et tellus euismod vulputate. Aliquam erat volutpat. Aenean gravida justo in risus feugiat, ut suscipit tortor ullamcorper. Nam a sapien dictum, vestibulum eros vitae, sodales turpis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed ultricies at elit et rutrum. Sed placerat erat quis condimentum convallis. Duis ornare magna nec ante faucibus malesuada. Duis a erat sed sapien semper eleifend. Mauris consequat nibh sollicitudin mi euismod, non ultricies lectus bibendum. Cras a erat libero. Aliquam nisl ipsum, scelerisque at risus a, hendrerit vestibulum sapien. Proin luctus diam eu mi lobortis molestie id vel ante."
#
#str_convert = StringConvertHtml.new(str, highlight_hsh)
#puts str_convert.to_html


def palindrome?(string)
  if string == string.reverse
    true
  else
    #puts "String is not a palindrome"
    false
  end
end

def sum_palindromes(n)
  pal_arr = []
  pal_sum = 0
  n.times.each do |i|
    if palindrome?(i.to_s)
      pal_arr << i
      pal_sum = pal_sum + i
    end
  end
  puts pal_sum
end

sum_palindromes(10000)


#def fibonacci(n)
#  a = 0
#  b = 1
#  odd_sum = 0
#  all_arr = []
#  odd_arr = []
#  # Compute Fibonacci number in the desired position.
#  (n - 1).times do
#    temp = a
#    a = b
#    # Add up previous two numbers in sequence.
#    b = temp + b
#    #puts a
#    all_arr << a
#    unless a % 2 == 0
#      odd_arr << a
#    end
#  end
#
#  odd_arr.each do |odd_a|
#    odd_sum = odd_sum + odd_a
#  end
#  #puts all_arr.inspect
#  #puts odd_arr.inspect
#  puts odd_sum.inspect
#end
#
#fibonacci(15)

def sumFibs(num)
  prevNumber = 0
  currNumber = 1
  result = 0
  while currNumber <= num
    if currNumber % 2 != 0
      result = result + currNumber
    end

    currNumber = currNumber + prevNumber
    prevNumber = currNumber - prevNumber
  end
  puts result
end

sumFibs(10000)


arabic_to_roman = {
    "1000": [1000, "M"],
    "900": [900, "CM"],
    "500": [500, "D"],
    "400": [400, "CD"],
    "100": [100, "C"],
    "90": [90, "XC"],
    "50": [50, "L"],
    "40": [40, "XL"],
    "10": [10, "X"],
    "9": [9, "IX"]
}

def count_occurrences_in_roman_notation(a_to_r, number, needle)
  count1 = 0
  a_to_r.each do |key, value|
    while number >= value[0]
      #puts value[1].count needle
      count1 = count1 + value[1].count(needle)
      number = number - value[0]
    end
  end
  count1
end


occurrence_count = 0
(2660 + 1).times.each do |i|
  res = count_occurrences_in_roman_notation(arabic_to_roman, i, "X")
  #puts "Result :: #{res.inspect}"
  occurrence_count += res
end

puts occurrence_count


def letters?(str)
  str.match(/[A-Za-z]/) ? true : false
end

def ascii_sum(str)
  vowels = ["a", "e", "i", "o", "u"]
  li = str.split("")
  #li[ : 0] = str
  result = []
  (li.length).times.each do |i|
    if vowels.include?(li[i])
      result << li[i].ord * -1
    elsif letters?(li[i])
      result << li[i].ord
    else
    end
  end
  # print(result)
  final = result.inject(0){|sum,x| sum + x }
  # print("The sum of the your string '{}'is: {}".format(str,final))
  puts final
end

str = "Dealing with failure is easy: Work hard to improve. Success is also easy to handle: You’ve solved the wrong problem. Work hard to improve."
ascii_sum(str)


