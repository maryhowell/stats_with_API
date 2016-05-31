require 'pry'
require "json"

class TransactionParser

attr_reader :path, :transaction, :content

  def initialize path
    @path = path
    @content = path
    @transaction = []
  end

  def parse!
    content.each do |trans|
      @transaction.push(Transaction.new trans.values[0], trans.values[1], trans.values[2], trans.values[3])
    end
  end
end
