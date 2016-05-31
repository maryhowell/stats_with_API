require 'pry'

class Transaction
  attr_reader :timestamp, :user_id, :item_id, :quantity

  def initialize timestamp, user_id, item_id, quantity
    @timestamp = timestamp
    @user_id = user_id
    @item_id = item_id
    @quantity = quantity
  end
end
