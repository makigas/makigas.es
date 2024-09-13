# frozen_string_literal: true

module Forum
  class DiscussionsTaggedAs < Forum::Request
    def initialize(*tags)
      super
      @tags = tags.map(&:to_s)
    end

    def cache_key
      "discussions/by_tag:#{@tags.sort.join(',')}"
    end

    def request(client)
      client.get('discussions', { 'filter[tag]': tags_query, 'page[limit]': 5, sort: '-createdAt' })
    end

    def process(response)
      included = hashify(response['included'] || [])
      response['data'].each_with_object({}) do |element, hash|
        value = element['attributes'].dup
        value['id'] = element['id'].to_i
        transclude(value, element['relationships'], included) if element['relationships'].present?
        hash[keyify(element)] = value
      end
    end

    private

    def transclude(into, relations, sources)
      relations.each do |key, value|
        if value['data'].is_a?(Array)
          into[key] = value['data'].map { |i| sources[keyify(i)] }
        elsif value['data'].is_a?(Hash)
          into[key] = sources[keyify(value['data'])]
        end
      end
    end

    def keyify(item)
      type, id = item.values_at('type', 'id')
      "#{type}/#{id}"
    end

    def hashify(arr)
      arr.each_with_object({}) do |element, hash|
        value = element['attributes'].dup
        value['id'] = element['id'].to_i
        hash[keyify(element)] = value
      end
    end

    def tags_query
      @tags.join(',')
    end
  end
end
