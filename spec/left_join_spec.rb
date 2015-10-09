require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Category < ActiveRecord::Base
  has_many :books
end

class Author < ActiveRecord::Base
  has_many :books
end

class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :category
end

describe 'LeftJoin' do
  it 'generates a LEFT OUTER JOIN SQL' do
    expect(Book.left_join(:category).to_sql).to eq(
      "SELECT \"books\".* FROM \"books\" LEFT OUTER JOIN \"categories\" ON "\
      "\"books\".\"category_id\" = \"categories\".\"id\"")
  end

  it 'works with nested associations' do
    expect(Category.left_join(books: :author).to_sql).to eq(
      "SELECT \"categories\".* FROM \"categories\" "\
      "LEFT OUTER JOIN \"books\" ON "\
      "\"categories\".\"id\" = \"books\".\"category_id\" "\
      "LEFT OUTER JOIN \"authors\" ON "\
      "\"books\".\"author_id\" = \"authors\".\"id\"")
  end

  it 'parses single argument to nodes' do
    expect(LeftJoin.parse_to_nodes(:category, Book)).to eq [
      Book.reflect_on_association(:category)]
  end

  it 'parses array argument to nodes' do
    expect(LeftJoin.parse_to_nodes([:category, :author], Book)).to eq [
      Book.reflect_on_association(:category),
      Book.reflect_on_association(:author)
    ]
  end

  it 'parses hash argument to nodes' do
    expect(LeftJoin.parse_to_nodes({ books: :author }, Category)).to eq [
      Category.reflect_on_association(:books),
      Book.reflect_on_association(:author)
    ]
  end
end
