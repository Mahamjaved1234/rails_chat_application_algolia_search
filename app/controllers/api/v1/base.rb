module API
    module V1
      class Base <Grape::API
        mount API::V1::Products
        mount API::V1::Retailers
        mount API::V1::Categories
        mount API::V1::Addresses
      end
    end
  end