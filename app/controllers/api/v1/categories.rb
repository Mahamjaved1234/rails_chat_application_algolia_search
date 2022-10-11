module API
    module V1
      class Categories <Grape::API
        version 'v1', using: :path
        format :json
        prefix :api
        resource :categories do
          desc 'Return All Products_category list in the company' 
         
          get do 
            # red = Redis.current
             Category.where(id: params[:id])
          end
         
          get :all do 
          
             Category.all
          end
        end
      end
    end
  end
    