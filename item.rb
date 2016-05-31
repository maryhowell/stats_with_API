class Item
  attr_reader :id, :name, :price, :category

  def initialize id, name, price, category = nil
    @id, @name, @price, @category = id, name, price, category
    freeze
  end
end
