module LeftJoin
  autoload :Node, 'left_join/node'

  def self.parse_to_nodes(arguments, context)
    [].tap do |result|
      case arguments
      when Hash
        arguments.each do |key, value|
          result.concat parse_to_nodes(key, context)
          result.concat parse_to_nodes(value, context.left_join_subcontext(key))
        end
      when Array
        arguments.each do |value|
          result.concat parse_to_nodes(value, context)
        end
      else
        result << context.node_for_left_join(arguments)
      end
    end
  end
end

require 'left_join/adapters/active_record_adapter'
