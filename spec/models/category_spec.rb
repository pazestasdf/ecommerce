require 'rails_helper'

RSpec.describe Category, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it 'is valid without a parent' do
    category = Category.create(name: 'Category 1')
    expect(category).to be_valid
  end

  it "destroy children when parent is destroyed" do
    category_0 = Category.create(name: 'Category 1')
    category_1 = Category.create(name: 'Category 1_1', parent: category_0)
    category_2 = Category.create(name: 'Category 1_2', parent: category_0)
    category_3 = Category.create(name: 'Category 1_3', parent: category_0)

    category_0.destroy
    assert_nil Category.find_by_id(category_1.id)
  end
end
