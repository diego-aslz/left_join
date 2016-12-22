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
  has_many :tags, as: :taggable
end

class Tag < ActiveRecord::Base
  belongs_to :taggable, polymorphic: true
end

describe 'LeftJoin' do
  it 'generates a LEFT OUTER JOIN SQL' do
    expect(Book.left_join(:category).to_sql).to eq(
      "SELECT \"books\".* FROM \"books\" LEFT OUTER JOIN \"categories\" ON "\
      "\"categories\".\"id\" = \"books\".\"category_id\"")
  end

  it 'aliases left_join as left_joins' do
    expect(Book.left_joins(:category).to_sql).to eq(
      "SELECT \"books\".* FROM \"books\" LEFT OUTER JOIN \"categories\" ON "\
      "\"categories\".\"id\" = \"books\".\"category_id\"")
  end

  it 'works with nested associations' do
    expect(Category.left_join(books: :author).to_sql).to eq(
      "SELECT \"categories\".* FROM \"categories\" "\
      "LEFT OUTER JOIN \"books\" ON "\
      "\"books\".\"category_id\" = \"categories\".\"id\" "\
      "LEFT OUTER JOIN \"authors\" ON "\
      "\"authors\".\"id\" = \"books\".\"author_id\"")
  end

  it 'works with polymorphic associations' do
    expect(Book.left_join(:tags).to_sql).to eq(
      "SELECT \"books\".* FROM \"books\" LEFT OUTER JOIN \"tags\" ON "\
      "\"tags\".\"taggable_id\" = \"books\".\"id\" AND "\
      "\"tags\".\"taggable_type\" = 'Book'")
  end
end
