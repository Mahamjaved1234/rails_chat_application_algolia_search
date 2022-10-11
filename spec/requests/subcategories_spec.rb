require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/subcategories", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Subcategory. As you add validations to Subcategory, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Subcategory.create! valid_attributes
      get subcategories_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      subcategory = Subcategory.create! valid_attributes
      get subcategory_url(subcategory)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_subcategory_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      subcategory = Subcategory.create! valid_attributes
      get edit_subcategory_url(subcategory)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Subcategory" do
        expect {
          post subcategories_url, params: { subcategory: valid_attributes }
        }.to change(Subcategory, :count).by(1)
      end

      it "redirects to the created subcategory" do
        post subcategories_url, params: { subcategory: valid_attributes }
        expect(response).to redirect_to(subcategory_url(Subcategory.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Subcategory" do
        expect {
          post subcategories_url, params: { subcategory: invalid_attributes }
        }.to change(Subcategory, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post subcategories_url, params: { subcategory: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested subcategory" do
        subcategory = Subcategory.create! valid_attributes
        patch subcategory_url(subcategory), params: { subcategory: new_attributes }
        subcategory.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the subcategory" do
        subcategory = Subcategory.create! valid_attributes
        patch subcategory_url(subcategory), params: { subcategory: new_attributes }
        subcategory.reload
        expect(response).to redirect_to(subcategory_url(subcategory))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        subcategory = Subcategory.create! valid_attributes
        patch subcategory_url(subcategory), params: { subcategory: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested subcategory" do
      subcategory = Subcategory.create! valid_attributes
      expect {
        delete subcategory_url(subcategory)
      }.to change(Subcategory, :count).by(-1)
    end

    it "redirects to the subcategories list" do
      subcategory = Subcategory.create! valid_attributes
      delete subcategory_url(subcategory)
      expect(response).to redirect_to(subcategories_url)
    end
  end
end
