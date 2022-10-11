class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  # GET companies/id?/products or /companies/id?/products.json
 def search
  query = params[:search_products].presence && params[:search_products][:query]

if query
  @products = Product.search_published(query)
end
 end
 
  def index
   red = Redis.new
   @brand = Brand.where(company_id: red.get("company_id"))
   @products = Product.where(brand_id: red.get("brand_id"))
   respond_to do |format|
       format.html  # index.html.erb
       format.json  { render :json => @products }
   end
      # $i = 0;
      # while @brand[$i] != nil
      #   $t_id = @brand[$i].id.to_i
      #   puts "My name is #{@brand[$i].name}"
      #   @products = Product.where(brand_id: @brand[$i].id)
      #   $i +=1;
      # end
    #   query = params["query"] || ""
    #   res = Product.search(query)
    #   puts "=============== #{res.response.hits}================="
    #  render json: res.response["hits"]["hits"]
  end
  # GET /companies/id?/products/1 or /companies/id?/products/1.json
  def show
    storage = Google::Cloud::Storage.new(
      project_id: "your project_id",
     credentials: "key.json"
    )
    bucket = storage.bucket "project_id.com"
    
   
      @product = Product.find(params[:id])
      if (file = bucket.file "#{@product.id}.jpg")
        @url = "link #{@product.id}.jpg?alt=media"
      else
        @url = "default link"
      end
  end
  def new
      @product = Product.new
      puts "#{@product}"
      respond_to do |format|
        format.html  # new.html.erb
        format.json  { render :json => @product }
      end
  end
  # POST /products/new
  def create
    red = Redis.new
      @product = Product.new(product_params)
      # @product[:brand_id] = 99
      @product.brand_id =  red.get("brand_id")
      
      $val = @product.availability
      # @product.availability = $val.to_b
      respond_to do |format|
          if @product.save
            file_data = product_params_image[:image].tempfile.path
            storage = Google::Cloud::Storage.new(
              project_id: "your project_id",
            credentials: "keyfile.json"
            )
            bucket = storage.bucket "project_id.com"
            
    file = bucket.create_file file_data , "#{@product.id}.jpg"
              format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
              format.json { render :show, status: :created, location: @product }
          else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @product.errors, status: :unprocessable_entity }
          end

         
      end
    end

    # GET /companies/id?/products/1/edit
def edit
  @product = Product.find(params[:id])
end
# PATCH/PUT /companies/id?/products/1 or /companies/id?/products/1.json
def update
  red = Redis.new
  if(red.get("shopper_id") == '0')
    puts"-==========COMPANY IS LOGGED IN =============-"
    respond_to do |format|
      if @product.update(product_params)
        file_data = product_params_image[:image].tempfile.path
        storage = Google::Cloud::Storage.new(
                   project_id: "project_id",
                 credentials: "keyfile.json"
                 )
                 bucket = storage.bucket "project_id.com"
                 file=bucket.create_file file_data , "#{@product.id}.jpg"
              
        format.html { redirect_to product_url(@product), notice: "Product was updated successfully." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  else
    puts"-++++++++++USER IS LOGGED IN #{red.get("shopper_id")}++++++++++++-"
    prod_qty=product_params[:quantity]
    @cart = Cart.where(shopper_id: red.get("shopper_id")).first
    if (@cart == nil)
      puts "Cart not found creating New cart"  
      @cart=Cart.new
      @cart.qty = prod_qty.to_i  
      @product = Product.find(params[:id])  
      puts "++++++++++++++++++++++++++++++++++++++++++++++++++++#{(@product.price).to_i}++++++++++++++++++++++++++++++++++++"
      @cart.total = (@product.price).to_i * prod_qty.to_i
      red.set("cart_#{@cart.id}_total","#{@cart.total}")
      red.set("cart_id","#{@cart.id}")
      @cart.shopper_id = red.get("shopper_id")
      prod = 
        [{
          "product_id"=> "#{@product.id}",
          "product_name"=> "#{@product.name}",
          "product_qty"=> "#{prod_qty.to_i}",  
          "product_total"=>"#{(@product.price).to_i * prod_qty.to_i}",  
          "retailer_id"=>"#{red.get("retailer_id")}",  
          "status": "false"  
        }].to_json
         @cart.products = prod
         @cart.save 
         puts "-=========PRODUCT IN CART AS: #{@cart.products}==========-"
         
    else  
      puts "Cart already exists"  
      @cart.qty += prod_qty.to_i  
      @product = Product.find(params[:id])  
      @prod_total = (@product.price).to_i * prod_qty.to_i  
      @cart.total += @prod_total  
      red.set("cart_#{@cart.id}_total","#{@cart.total}")  
      prod = @cart.products + [  
        {  
          "product_id" => "#{@product.id}",  
          "product_name" => "#{@product.name}",  
          "product_qty" => "#{prod_qty.to_i}",  
          "product_total" => "#{(@product.price).to_i * prod_qty.to_i}",  
          "retailer_id" => "#{red.get("retailer_id")}",  
          "status" => "false"  
        }  
      ].to_json
        @cart.products = prod  
     
         @cart.save  
    end
    puts "-=========PRODUCT IN CART AS: #{@cart.products}==========-"

   
    respond_to do |format|  
      if @cart.save  
        puts "-=========PRODUCT IN CART AS AFTER : #{@cart.id}==========-"
        format.html { redirect_to cart_url(@cart), notice: "Add to cart" }
        format.json { render :show, status: :created, location: @cart }  
      else  
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end

  end
 end



# DELETE /companies/id?/products/1 or /companies/id?/products/1.json
def destroy
  @product.destroy
  respond_to do |format|
    format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
    format.json { head :no_content }
  end
end
private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    red = Redis.new
    @product = Product.find(params[:id])
    @brand = Brand.find(2)
    @company = Company.find('630dfeeb4ff2355fd7ec5bf2')

    red.set("product_id","#{@product.id}")
    puts"========= REDIS SAVED PRODUCT ID #{red.get("product_id")} ========="
    red.set("company_id","#{@company.id}")
    puts"========= REDIS SAVED COMPANY ID #{red.get("company_id")} ========="
  end
  # Only allow a list of trusted parameters through.
  def product_params_image
    params.require(:product).permit(:name, :description, :price, :brand_id, :availability, :quantity, :subcategory , :image)
  end
  def product_params
    params.require(:product).permit(:name, :description, :price, :brand_id, :availability, :quantity, :subcategory_id)
  end
end
