class XyzController < ApplicationController



        # def create
        #     @shopper = Shopper.new(login_params)
        
        #     respond_to do |format|
        #       if @shopper.save
        #         format.html { redirect_to company_url(@shopper), notice: "Retailer was successfully created." }
        #         format.json { render :show, status: :created, location:@shopper}
        #       else
        #         format.html { render :new, status: :unprocessable_entity }
        #         format.json { render json: @shopper.errors, status: :unprocessable_entity }
        #       end
        #     end
        #   end


    def index
        puts " -===================== THIS ONE IS REAL ONE NOT DEVISE ONE =======================- "
        company = Company.find_by(email:login_params[:email])
        if company == nil
            shopper = Shopper.find_by(email:login_params[:email])
            if shopper == nil
                retailer = Retailer.find_by(email:login_params[:email])
                if retailer == nil
                    puts "=========== PLEASE ENTER CORRECT CREDENTIALS ============"
                    flash[:login_errors] = ['invaild credentials']
                    redirect_to '/'
                else
                if retailer.password ==  login_params[:password]
                    puts"---------------- YES LOGIN IS CALLED USING RETAILER PARAMS OF #{retailer.name} ---------------"
                
                    Redis.current.mset("retailer_id", "#{retailer.id}", "retailer_name", "#{retailer.name}", "retailer_email", "#{retailer.email}")
                    puts"=======================REDIS SAVED RETAILER ID: #{Redis.current.get("retailer_id")} \nREDIS SAVED RETAILER NAME: #{Redis.current.get("retailer_name")} ======================="
                    # EmailJob.perform_now(1) #1 means this one has to go for login mail for Shopper 
                    redirect_to '/orders'
                else
                    puts "=========== PLEASE ENTER CORRECT CREDENTIALS ============"
                    flash[:login_errors] = ['invaild credentials']
                    redirect_to '/'
                end
              end
            else
                if shopper.password ==  login_params[:password]
                    # puts"---------------- YES LOGIN IS CALLED USING SHOPPER PARAMS OF #{shopper.name}  "shopper_name", "#{shopper.name}"---------------"
                 
                    Redis.current.mset("shopper_id", "#{shopper.id}", "shopper_email", "#{shopper.email}")
                    puts"=======================REDIS SAVED SHOPPER ID: #{Redis.current.get("shopper_id")}===================="
                    # EmailJob.perform_now(1) #1 means this one has to go for login mail for Shopper 
                    redirect_to '/addresses'
                else
                    flash[:login_errors] = ['invaild credentials']
                    redirect_to '/'
                end
            end
        else
            if company.password ==  login_params[:password]



                
             puts"---------------- YES LOGIN IS CALLED USING COMPANY PARAMS OF #{company.name}"

                Redis.current.mset("company_id","#{company.id}", "company_name","#{company.name}", "company_email","#{company.email}")
                puts"=======================REDIS SAVED COMPANY ID: #{Redis.current.get("company_id")}===================="
                puts"=======================REDIS SAVED COMPANY NAME: #{Redis.current.get("company_name")} \nREDIS SAVED COMPANY EMAIL: #{Redis.current.get("company_email")} ===================="
                # EmailJob.perform_now(1) #1 means this one has to go for login mail for Shopper 
                redirect_to '/brands'
            else
               flash[:login_errors] = ['invaild credentials']
               redirect_to '/'
            end
    end
    
    def destroy
        puts "YES DESTROYED IS CALLED ------ YES IM CALLED"
        redirect_to '/'
    end
end
    private 
     def login_params
        params.require(:login).permit(:email, :password)
     end

end