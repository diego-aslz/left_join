module LeftJoin
  module Adapters
    module ActiveRecordAdapter
      # Does a left join through an association. Usage:
      #
      #     Book.left_join(:category)
      #     # SELECT "books".* FROM "books"
      #     # LEFT OUTER JOIN "categories"
      #     # ON "books"."category_id" = "categories"."id"
      #
      # It also works through association's associations, like `joins` does:
      #
      #     Book.left_join(category: :master_category)
      def left_join(*columns)
        joins(ActiveRecord::Associations::JoinDependency.new(self, columns, []))
      end
    end

    ActiveRecord::Base.extend ActiveRecordAdapter if defined?(ActiveRecord)
  end
end
