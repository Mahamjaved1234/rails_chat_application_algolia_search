# require 'csv'
class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :description, type: String
  field :subcategory_id, type: String
  field :brand_id, type: String
  field :price, type: String
  field :quantity, type: String
  field :availability, type: Boolean
  #  belongs_to :subcategory
    # validates :name, :presence => true,uniqueness: true
    # validates :price, :presence => true
    # validates :description, :presence=> true
    #  include Searchable

    # include AlgoliaSearch
    # algoliasearch do
    #     attributes :name, :price, :quantity , :description
    #     # filters: 'name:Airmax-Zero'
    #     searchableAttributes ['price','quantity']

    #     # the `customRanking` setting defines the ranking criteria use to compare two matching
    #     # records in case their text-relevance is equal. It should reflect your record popularity.
    #     customRanking ['desc(price)']
    #   end
    # belongs_to :brands
end
