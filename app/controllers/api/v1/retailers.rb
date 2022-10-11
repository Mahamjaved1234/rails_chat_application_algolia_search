module API
  module V1
    class Retailers <Grape::API
      version 'v1', using: :path
      format :json
      prefix :api
      resource :retailers do
        desc 'Return All Products to manage'
        get do
          red = Redis.new
          Product.where(brand_id:"1")
        end
        put do
          @prd = Product.find(params[:id]).update({price: "#{params[:price]}",quantity: "#{params[:quantity]}", availability: "#{params[:availability]}"})
        end
      end
    end
  end
end
  