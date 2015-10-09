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
        LeftJoin.parse_to_nodes(columns, self).inject(all) do |acc, association|
          table = association.active_record.arel_table
          join_table = association.klass.arel_table
          foreign_key = association.foreign_key
          primary_key = association.association_primary_key.to_sym
          unless association.belongs_to?
            foreign_key, primary_key = primary_key, foreign_key
          end

          arel_join = table.join(join_table, Arel::Nodes::OuterJoin) \
                      .on(table[foreign_key].eq(join_table[primary_key]))
          acc.joins(arel_join.join_sources)
        end
      end

      def node_for_left_join(key)
        reflect_on_association(key) ||
          fail("#{self} has no association: #{key}.")
      end

      def left_join_subcontext(key)
        node_for_left_join(key).klass
      end
    end

    ActiveRecord::Base.extend ActiveRecordAdapter if defined?(ActiveRecord)
  end
end

