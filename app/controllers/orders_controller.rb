class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    red=Redis.new
    @orders = Order.where(shopper_id:red.get("shopper_id"))
  end

  # GET /orders/1 or /orders/1.json
  def show
    red = Redis.new
  end

  # GET /orders/new
  def new
    red=Redis.new
    @order = Order.new
    @order.shopper_id = red.get("shopper_id");
    @order.status=false;
    @order.address = red.get("address");
    @order.retailer_id = red.get("retailer_id");
    @cart = Cart.where(shopper_id: red.get("shopper_id"))
    @order.products = @cart[0].products #red.get("product_id");
    @order.grand_total = @cart[0].total
    $i =0;
    while @cart[$i] != nil
      $grand_total = @cart[$i].total.to_i
      $i += 1
    end
    red.set("grand_total-#{@order.id}","#{@cart[0].total}")
    @ogt = red.get("grand_total-#{@order.id}")
    @un = red.get("shopper_name")
    @order.save
    Cart.where(shopper_id: red.get("shopper_id")).destroy_all
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    respond_to do |format|
      if @order.save
        format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update    
    ########### KAFKA ##############
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
      order_id: "#{@order.id}",
      status: @order.status,
      timestamp: Time.now,
    }
    #  partition_key = rand(100)
    producer.produce(event.to_json,topic: "order-test-event")
    producer.deliver_messages      

    respond_to do |format|
      if @order.update(order_params)
        # ContactJob.perform_now params.permit(:order)[:status]
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      red = Redis.new
      @order = Order.find(params[:id])
      @cart = Cart.where(shopper_id: red.get("shopper_id"))
      puts "================CART FOUND AS: #{@cart[0]}================="
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:status)
    end
end


# class OrdersController < ApplicationController
#   before_action :set_order, only: %i[ show edit update destroy ]

#   # GET /orders or /orders.json
#   def index
#     @orders = Order.all
#   end

#   # GET /orders/1 or /orders/1.json
#   def show
#   end

#   # GET /orders/new
#   def new
#     @order = Order.new
#   end

#   # GET /orders/1/edit
#   def edit
#   end

#   # POST /orders or /orders.json
#   def create
#     @order = Order.new(order_params)

#     respond_to do |format|
#       if @order.save
#         format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
#         format.json { render :show, status: :created, location: @order }
#       else
#         format.html { render :new, status: :unprocessable_entity }
#         format.json { render json: @order.errors, status: :unprocessable_entity }
#       end
#     end
#   end

#   # PATCH/PUT /orders/1 or /orders/1.json
#   def update
#     respond_to do |format|
#       if @order.update(order_params)
#         format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
#         format.json { render :show, status: :ok, location: @order }
#       else
#         format.html { render :edit, status: :unprocessable_entity }
#         format.json { render json: @order.errors, status: :unprocessable_entity }
#       end
#     end
#   end

#   # DELETE /orders/1 or /orders/1.json
#   def destroy
#     @order.destroy

#     respond_to do |format|
#       format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
#       format.json { head :no_content }
#     end
#   end

#   private
#     # Use callbacks to share common setup or constraints between actions.
#     def set_order
#       @order = Order.find(params[:id])
#     end

#     # Only allow a list of trusted parameters through.
#     def order_params
#       params.require(:order).permit(:status)
#     end
# end