module Arelastic
  class Relation
    attr_accessor :query_value,
                  :filter_values,
                  :limit_value,
                  :offset_value,
                  :facet_values

    def initialize
      @filter_values = []
      @query_values = []
      @limit_value = nil
      @offset_value = nil
    end

    def index
      @index ||= Arelastic::Index.new
    end

    def query!(value)
      self.query_value = value
    end

    def query(value)
      clone.query!(value)
    end

    def filter!(*args)
      self.filter_values += args.flatten
    end

    def filter(*args)
      clone.filter!(*args)
    end

    def limit!(value)
      self.limit_value = value
      self
    end

    def limit(value)
      clone.limit!(value)
    end

    def offset!(value)
      self.offset_value = value
      self
    end

    def offset(value)
      clone.offset!(value)
    end

    def facet!(*args)
      self.facet_values = args.flatten
    end

    def facet(*args)
      clone.facet!(*args)
    end

    def as_elastic
      build_search.as_elastic
    end

    def build_search
      searches = [
        build_query_and_filter(query_value, filter_values),
        build_limit(limit_value),
        build_offset(offset_value),
      ].compact

      Arelastic::Nodes::Grouping.new searches
    end

    private
      def build_query_and_filter(query, filters)
        query = build_query(query)
        filter = build_filter(filters)
        if query && filters
          Arelastic::Searches::Query.new(Arelastic::Queries::Filtered.new(query, filter))
        elsif query
        elsif filters
          Arelastic::Searches::Query.new(Arelastic::Queries::ConstantScore.new(filter))
        end
      end

      def build_query(query)
        if query.is_a?(String)
          query = {query_string: query}
        end

        if query
          Arelastic::Searches::Query.new query
        end
      end

      def build_filter(filters)
        nodes = []

        filters.map do |filter|
          if filter.is_a?(Arelastic::Filters::Filter)
            nodes << filter
          else
            filter.each do |field, terms|
              nodes << (terms.is_a?(Array) ? Arelastic::Filters::Terms : Arelastic::Filters::Term).new(field, terms)
            end
          end
        end

        if nodes.size == 1
          Arelastic::Searches::Filter.new nodes.first
        elsif nodes.size > 1
          Arelastic::Searches::Filter.new Arelastic::Filters::And.new(nodes)
        end
      end

      def build_limit(limit)
        if limit
          Arelastic::Searches::Size.new(limit)
        end
      end

      def build_offset(offset)
        if offset
          Arelastic::Searches::From.new(offset)
        end
      end

      def build_facets(facets)
        nodes = []
        facets.each do |yay|
          nodes << 'x'
        end

        Arelastic::Searches::Facets.new(nodes) unless nodes.empty?
      end
  end
end