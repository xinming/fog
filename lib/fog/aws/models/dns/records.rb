require 'fog/core/collection'
require 'fog/aws/models/dns/record'

module Fog
  module DNS
    class AWS

      class Records < Fog::Collection

        attribute :is_truncated,            :aliases => ['IsTruncated']
        attribute :max_items,               :aliases => ['MaxItems']
        attribute :name
        attribute :next_record_name,        :aliases => ['NextRecordName']
        attribute :next_record_type,        :aliases => ['NextRecordType']
        attribute :next_record_identifier,  :aliases => ['NextRecordIdentifier']
        attribute :type
        attribute :identifier

        attribute :zone

        model Fog::DNS::AWS::Record

        def all(options = {})
          requires :zone
          options[:max_items]  ||= max_items
          options[:name]       ||= name
          options[:type]       ||= type
          options[:identifier] ||= identifier

          data = connection.list_resource_record_sets(zone.id, options).body
          # NextRecordIdentifier is completely absent instead of nil, so set to nil, or iteration breaks.
          data['NextRecordIdentifier'] = nil unless data.has_key?('NextRecordIdentifier')

          merge_attributes(data.reject {|key, value| !['IsTruncated', 'MaxItems', 'NextRecordName', 'NextRecordType', 'NextRecordIdentifier'].include?(key)})
          # leave out the default, read only records
          data = data['ResourceRecordSets'].reject {|record| ['NS', 'SOA'].include?(record['Type'])}
          load(data)
        end

        def get(record_id)
          data = connection.get_change(record_id).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

        def new(attributes = {})
          requires :zone
          super({ :zone => zone }.merge!(attributes))
        end

      end

    end
  end
end
