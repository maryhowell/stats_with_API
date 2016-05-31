require "pry"
require "./item"
require "./user"
require "./data_parser"
require "./transaction_parser"
require "./transaction"
require 'httparty'



data = HTTParty.get(
"https://shopnatra.herokuapp.com/data",
query: {
  password: "hunter2"
}
)

trans = HTTParty.get(
"https://shopnatra.herokuapp.com/transactions/05_05_05",
query: {
  password: "hunter2"
}
)

#
# def file_path file_name
#   File.expand_path "../data/#{file_name}.json", __FILE__
# end

d = DataParser.new data
t = TransactionParser.new trans

d.parse!
t.parse!

#Start stats -----------------
users_max = {}
users_max.default = 0

t.transaction.each do |x|
  users_max[x.user_id] = users_max[x.user_id] + 1
end

max = users_max.max_by {|u,v|v}
user_most_orders = ""
d.users.each do |a|
  if a.id == max.first
    user_most_orders = a.name
  end
end
puts "The user that made the most orders was #{user_most_orders}"
#--------------------

number_of_lamps = 0
erl_id = 0

d.items.each do |i|
 if i.name == "Ergonomic Rubber Lamp"
   erl_id = i.id
 end
end

t.transaction.each do |q|
  if q.item_id == erl_id
    number_of_lamps += q.quantity
  end
end
puts "We sold #{number_of_lamps} Ergonomic Rubber Lamps"
#------------------------------------

all_id_of_tools = []

d.items.each do |t|
  if t.category.include? "Tools"
    all_id_of_tools.push t.id
  end
end

number_of_tools = 0
  t.transaction.each do |t|
    if all_id_of_tools.include? t.item_id
      number_of_tools += t.quantity
    end
  end

puts "We sold #{number_of_tools} items from the Tools category"
#-----------------------------------

id_price = {}
d.items.each do |i|
  id_price[i.id] = i.price
end

id_quantity = {}
id_quantity.default = 0
t.transaction.each do |t|
  id_quantity[t.item_id] += t.quantity
end

total_revenue = 0
id_price.each do |id, price|
  total_revenue += price * id_quantity[id]
end

puts "Our total revenue was $#{total_revenue.round(2)}"
#-----------------------------------

ids_by_category = {"Tools" => [], "Health" => [], "Electronics" => [], "Kids" => [],
                 "Computers" => [], "Jewelery" => [], "Games" => [], "Books" => [],
                 "Garden" => [], "Movies" => [], "Music" => [], "Beauty" => [],
                 "Industrial" => [],"Automotive" => [], "Sports" => [], "Outdoors" => [],
                 "Clothing" => []}

d.items.each do |t|
  ids_by_category.each do |cat, ids|
    if t.category.include? cat
      ids.push t.id
    end
  end
end

revenue_by_item = {}

id_price.each do |pid, price|
  id_quantity.each do |qid, quant|
    if pid == qid
      revenue_by_item[pid] = price * quant
    end
  end
end


highest_grossing_category = []
revenue_by_category = {}
revenue_by_category.default = 0

ids_by_category.each do |cati, cids|
  revenue_by_item.each do |rid, rev|
    if cids.include? rid
      revenue_by_category[cati] += rev
    end
  end
end

max_rev_category =revenue_by_category.max_by{|key,value| value}

puts "Harder: the highest grossing category was #{max_rev_category.first}"
