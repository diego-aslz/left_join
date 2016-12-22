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
        join_dependency = ActiveRecord::Associations::JoinDependency.new(self, columns, [])
        if RAILS4_1_PLUS
          joins(join_dependency)
        else
          join_dependency.join_associations.inject(self) do |result, association|
            association.join_relation(result)
          end
        end
      end

      alias_method :left_joins, :left_join
    end

    if defined?(ActiveRecord)
      ActiveRecord::Base.extend ActiveRecordAdapter
      RAILS4_1_PLUS = ActiveRecord::VERSION::MAJOR > 4 || (4 == ActiveRecord::VERSION::MAJOR && ActiveRecord::VERSION::MINOR >= 1)
    end
  end
end
