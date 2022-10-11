class AddressesController < ApplicationController
  before_action :set_address, only: %i[ show edit update destroy ]
  before_action :require_user

  # GET /addresses or /addresses.json
  def index
    red = Redis.new
    @addresses = Address.where(shopper_id: Redis.current.get("shopper_id"))
    # url = "http://"
  
  end

  # GET /addresses/1 or /addresses/1.json
  def show
    
  end

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses or /addresses.json
  def create
    red = Redis.new
    @address = Address.new(address_params)
  
    @address.shopper_id = red.get("shopper_id")
    @address.shopper_address = red.get("shopper_address")
    respond_to do |format|
      if @address.save
        format.html { redirect_to address_url(@address), notice: "Address was successfully created." }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addresses/1 or /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to address_url(@address), notice: "Address was successfully updated." }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1 or /addresses/1.json
  def destroy
    @address.destroy

    respond_to do |format|
      format.html { redirect_to addresses_url, notice: "Address was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id]) 
      address = Address.find(params[:id]) 
      red = Redis.new
      red.set("address_id","#{address.id}")
      red.set("shopper_address","#{address.detail}")
      puts"========= REDIS NE ADDRESS ID #{red.get("address_id")} SAVE KARDI HIA ========="
      puts"========= REDIS NE SHOPPER NAME #{red.get("shopper_name")} SAVE KARDIA HAI ========="
      
      # user_signed_in = User.find_by_id(.id)
      # current_user = User.find_by_id(shopper.id)
      # user_session = User.find_by_id(shopper.id)
#       require "kafka"

#       # Configure the Kafka client with the broker hosts and the Rails
#       # logger.
#       kafka = Kafka.new(["localhost:9092"],logger: Rails.logger)
#       # kafka = Kafka.new
#       producer = kafka.producer
#       event = {
#            order_id: "#{@address.id}",
#           # status: @order.status,
#            timestamp: Time.now,
#          }
# # Add a message to the producer buffer.
#       producer.produce(event.to_json, topic: "test-messages")

# # Deliver the messages to Kafka.
#       producer.deliver_messages
     

      # kafka.each_message(topic: "test-messages") do |message|
      #   puts message.offset, message.key, message.value
      # end
      
      # event = {
      #    order_id: "#{@address.id}",
      #   # status: @order.status,
      #   timestamp: Time.now,
      # }
      # kafka.producer.produce(event.to_json, topic:"greetings",partition:42)
      # # producer = Kafka.async_producer
      # # producer = kafka.async_producer(
      # #   delivery_interval: 5,
      # # )
      # # producer.produce(topic:"greetings")

      # kafka.producer.deliver_messages
      # # kafka.each_messages(topic:"greetings", start_from_beginning: true) do |message|
      # #   puts "KAFKA ====================================================#{message}"
      # # end
      # puts "================================#{@seed_brokers}"
      # offset = :earliest
      # loop do
      #   messages = kafka.fetch_messages(
      #     topic: "greetings",
      #     partition: 42,
      #     offset: offset,
      #   )
      #   messages.each do |message|
      #     puts message.offset, message.key, message.value
      
      #     # Set the next offset that should be read to be the subsequent
      #     # offset.
      #     offset = message.offset + 1
      #   end
      # end
      # (topic: "greetings") do |message|
      #   puts "KAFKA ====================================================#{message}"
      # end
      @categories= Category.all
      @retailers=Retailer.all
      @ordersPending = Order.where(address_id: @address.id, status: false)
      @ordersCompleted = Order.where(address_id: @address.id, status: true)
    end

    # Only allow a list of trusted parameters through.
    def address_params
      params.require(:address).permit(:detail, :name)
    end
    
end
