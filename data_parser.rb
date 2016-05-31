require "json"

require "./user"
require "./item"

class DataParser
  attr_reader :path, :users, :items

  def initialize path
    @path = path
    @users = []
    @items = []
  end

  def parse!
    raw = path

    @users = raw["users"].map do |hash|
      User.new(
        hash["id"],
        hash["name"],
        hash["address"]
      )
    end

    @items = raw["items"].map do |hash|
      Item.new(
        hash["id"],
        hash["name"],
        hash["price"],
        hash["category"]
      )
    end
  end
end
