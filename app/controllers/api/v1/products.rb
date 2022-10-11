module API
    module V1
      class Products <Grape::API
        version 'v1', using: :path
        format :json
        prefix :api
        resource :products do
            desc 'Return All Products'
            get do 
              red = Redis.current
               Product.where(brand_id: red.get('brand_id')).select(:id,:name,:price,:brand_id,:quantity,:availability)
              
            end

            post :status do 
           
               Product.where(availability: params[:status]).select(:id,:name,:price,:brand_id,:quantity,:availability)
            end
            post :place_order do 
           
              red=Redis.current
              @order = Order.new
              @order.shopper_id = params[:shopper_id];
              @order.status=false;
              @order.address = red.get("address");
              @order.retailer_id = red.get("retailer_id");
              @cart = Cart.where(shopper_id: red.get("shopper_id"))
              product=Product.find_by(name: params[:products])
              @order.products = params[:products]#red.get("product_id");
              @order.grand_total = product.price
              $i =0;
              while @cart[$i] != nil
                $grand_total = @cart[$i].total.to_i
                $i += 1
              end
              red.set("grand_total-#{@order.id}","#{product.price}")
              @ogt = red.get("grand_total-#{@order.id}")
              @un = red.get("shopper_name")
              @order.save
              Cart.where(shopper_id: red.get("shopper_id")).destroy_all
              present @order
           end
        put :update_order do 

          require "kafka"
    # kafka = Kafka.new(seed_brokers: "9092", client_id: "eshop", logger: Rails.logger)
    kafka = Kafka.new(seed_brokers:["localhost:9092"],logger: Rails.logger)
    producer = kafka.async_producer(
      # Trigger a delivery once 100 messages have been buffered.
      delivery_threshold: 100,
      # Trigger a delivery every 30 seconds.
      delivery_interval: 30,
    )
    event = {
      order_id: params[:id],
      status: params[:status],
      timestamp: Time.now,
    }
    #  partition_key = rand(100)
    producer.produce(event.to_json,topic: "order-test-event")
    producer.deliver_messages      

    # respond_to do |format|
    #   if @order.update(order_params)
    #     format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
    #     format.json { render :show, status: :ok, location: @order }
    #   else
    #     format.html { render :edit, status: :unprocessable_entity }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end

    
        end




        end
      end
    end
  end