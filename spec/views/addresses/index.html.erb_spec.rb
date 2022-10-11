require 'rails_helper'

RSpec.describe "addresses/index", type: :view do
  before(:each) do
    assign(:addresses, [
      Address.create!(
        detail: "MyText",
        name: "Name"
      ),
      Address.create!(
        detail: "MyText",
        name: "Name"
      )
    ])
  end

  it "renders a list of addresses" do
    render
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Name".to_s, count: 2
  end
end
