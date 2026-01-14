OrderItem.delete_all
Order.delete_all
Item.delete_all
Category.delete_all
User.delete_all

puts "Seeding users..."

# Users
users = [
  { name: "Rachel Warbelow", email: "demo+rachel@jumpstartlab.com", password: "password", display_name: nil },
  { name: "Jeff Casimir", email: "demo+jeff@jumpstartlab.com", password: "password", display_name: "j3" },
  { name: "Jorge Tellez", email: "demo+jorge@jumpstartlab.com", password: "password", display_name: "novohispano" },
  { name: "Josh Cheek", email: "demo+josh@jumpstartlab.com", password: "password", display_name: "josh", role: :admin }
]

users.each { |attrs| User.create!(attrs) }

puts "Seeding categories..."

# Food Categories
category_names = ["Appetizers", "Main Course", "Desserts", "Beverages", "Salads"]
categories = category_names.map { |name| Category.create!(name: name, slug: name.parameterize) }

puts "Seeding items..."

# Food items (sample menu)
menu_items = [
  { title: "Spring Rolls", category: "Appetizers", price: 5.99 },
  { title: "Garlic Bread", category: "Appetizers", price: 4.50 },
  { title: "Cheeseburger", category: "Main Course", price: 10.99 },
  { title: "Grilled Chicken", category: "Main Course", price: 12.50 },
  { title: "Veggie Pizza", category: "Main Course", price: 11.00 },
  { title: "Chocolate Cake", category: "Desserts", price: 6.50 },
  { title: "Ice Cream Sundae", category: "Desserts", price: 5.00 },
  { title: "Coke", category: "Beverages", price: 2.00 },
  { title: "Lemonade", category: "Beverages", price: 2.50 },
  { title: "Caesar Salad", category: "Salads", price: 7.50 },
  { title: "Greek Salad", category: "Salads", price: 8.00 },
  { title: "Chicken Wings", category: "Appetizers", price: 6.99 },
  { title: "Pasta Alfredo", category: "Main Course", price: 12.00 },
  { title: "Brownie", category: "Desserts", price: 4.50 },
  { title: "Orange Juice", category: "Beverages", price: 3.00 },
  { title: "Garden Salad", category: "Salads", price: 6.50 },
  { title: "Taco", category: "Main Course", price: 9.50 },
  { title: "Margarita Pizza", category: "Main Course", price: 10.50 },
  { title: "Cheesecake", category: "Desserts", price: 6.00 },
  { title: "Iced Tea", category: "Beverages", price: 2.50 }
]

menu_items.each_with_index do |item_attrs, i|
  category = categories.find { |c| c.name == item_attrs[:category] }
  Item.create!(
    title: item_attrs[:title],
    description: "Delicious #{item_attrs[:title]} prepared fresh.",
    price: item_attrs[:price],
    category: category,
    slug: item_attrs[:title].parameterize,
    retired: [false, false, true].sample
  )
end

puts "Seeding orders..."

users_without_admin = User.where.not(role: :admin)
statuses = %w[ordered completed cancelled paid]

10.times do
  user = users_without_admin.sample
  order = Order.create!(
    user: user,
    first_name: user.name.split.first,
    last_name: user.name.split.last,
    email: user.email,
    status: statuses.sample,
    total_amount: 0,
    payment_method: "cod",
    address: "123 Main St",
    city: "Sample City",
    phone: "1234567890",
    zip: "12345"
  )

  # Add 1-4 menu items to each order
  items = Item.order("RANDOM()").limit(rand(1..4))
  total = 0

  items.each do |item|
    quantity = rand(1..3)
    price = item.price
    total += price * quantity

    OrderItem.create!(
      order: order,
      item: item,
      quantity: quantity,
      price: price
    )
  end

  order.update!(total_amount: total)
end

puts "Restaurant seed data complete!"
