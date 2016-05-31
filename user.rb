class User
  attr_reader :id, :name, :address

  def initialize id, name, address
    @id, @name, @address = id, name, address
    freeze
  end
end
