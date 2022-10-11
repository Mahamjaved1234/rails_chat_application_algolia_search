# require 'grape_jsonapi'
module API
    module V1
      class Addresses <Grape::API
        version 'v1', using: :path
        format :json
        # formatter :json, Grape::Formatter::JSONAPIResources
        prefix :api
        resource :addresses do
          desc 'sign up shopper and add delivery addresses'
          get :show do
            Shopper.all
          end

          post :signup do
            @shopper = Shopper.where(email:params[:email],password:params[:password])#.select(:id,:name,:password)
            # red=Redis.new
            # red.set("shopper_id","#{shopper.id}")
               
            #     puts"========= REDIS NE SHOPPER ID #{red.get("shopper_id")} SAVE KARDI HAI ========="
            #     red.set("shopper_name","#{shopper.name}")
            present @shopper
            
          end

          post :add_address do
             shopper = Shopper.find_by(email:params[:email],password:params[:password])
             if shopper.encrypted_password == params[:password]
            red=Redis.current
            red.set("shopper_id","#{shopper.id}")
             end
                @address= Address.new(detail:params[:detail] , name:params[:name],shopper_id:red.get("shopper_id"))
                @address.save

                present @address
            #  end
          end

          get :show_shopper_address do
            # red=Redis.current
            @shopper_addr = Address.where(shopper_id: Redis.current.get("shopper_id")).select(:id, :detail, :name)
            # puts "===============| #{@shopper_addr[0].name} |==============="
           
            present @shopper_addr
          end
          post :select_address do
            
            shopper_addr = Address.where(name: params[:name])
            # puts "=======================#{shopper_addr.name}"
            # Redis.current.set("default_addr","#{shopper_addr[:id]}")
            # puts "=====================REDIS NE DEFAULT ADDRESS #{shopper_addr[:id]} SAVE KAR DIA HAI========================"
            present shopper_addr
             #after selecting default addresses show list of retailers available 
            # redirect :show_retailers #show list of retailers available 
          
          end
          
         
          get :show_retailers do
            # shopper = Shopper.find_by(email:params[:email],pass:params[:password])
            # if shopper.pass == params[:password]
           
           retailers=Retailer.all
           red=Redis.current
           red.set("default_addr","#{retailers[0].id}")
           puts "=====================REDIS NE DEFAULT ADDRESS #{retailers[0].id} SAVE KAR DIA HAI========================"
            present retailers # show list of retailers available 
           
          end


          # get :select_addr do
          #   # shopper = Shopper.find_by(email:params[:email],pass:params[:password])
          #   # if shopper.pass == params[:password]
           
          #   shopper_addr = Address.where(id: Redis.current.get("default_addr"))
          #   present shopper_addr #after selecting default addresses show list of retailers available 
          #   # redirect :show_retailers #show list of retailers available 
          
          #   #  end
       
        end
      end
    end
  end
    