
module Searchable
    extend ActiveSupport::Concern
  
    included do
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks
  
      mapping do
        # mapping definition goes here

              indexes :name, type: :keyword
              indexes :price, type: :integer
              indexes :description, type: :text
            
      end
  
      def self.search_published(query)
        
        self.__elasticsearch__.search(query)
      end
    end
  end