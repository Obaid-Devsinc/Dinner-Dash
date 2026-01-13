# db/seeds.rb

categories = Category.all.to_a

if categories.empty?
  puts "No categories found! Please create some categories first."
else
  items = [
    { title: 'Beef Shawarma', description: 'Delicious Middle Eastern wrap', price: 9.99 },
    { title: 'Beef Burger', description: 'Juicy grilled beef burger', price: 8.49 },
    { title: 'Veggie Pizza', description: 'Fresh vegetables with cheese', price: 7.99 },
    { title: 'Spaghetti Bolognese', description: 'Classic Italian pasta', price: 10.50 },
    { title: 'Caesar Salad', description: 'Crisp lettuce with Caesar dressing', price: 6.99 },
    { title: 'Chocolate Cake', description: 'Rich and moist', price: 4.99 },
    { title: 'French Fries', description: 'Crispy golden fries', price: 3.50 },
    { title: 'Grilled Chicken Sandwich', description: 'Tender grilled chicken', price: 8.99 },
    { title: 'Fish Tacos', description: 'Fresh fish with spicy slaw', price: 9.50 },
    { title: 'Chicken Wings', description: 'Spicy buffalo wings', price: 7.50 },
    { title: 'Cheeseburger', description: 'Classic beef cheeseburger', price: 8.99 },
    { title: 'Margherita Pizza', description: 'Tomato, basil, mozzarella', price: 7.50 },
    { title: 'Penne Alfredo', description: 'Creamy pasta with cheese', price: 9.99 },
    { title: 'Greek Salad', description: 'Feta cheese and olives', price: 6.50 },
    { title: 'Tiramisu', description: 'Coffee-flavored Italian dessert', price: 5.50 },
    { title: 'Onion Rings', description: 'Crispy battered onions', price: 3.99 },
    { title: 'BBQ Chicken Pizza', description: 'Grilled chicken with BBQ sauce', price: 8.99 },
    { title: 'Vegetable Stir Fry', description: 'Fresh veggies with soy sauce', price: 7.50 },
    { title: 'Cheese Nachos', description: 'Loaded nachos with melted cheese', price: 6.99 },
    { title: 'Buffalo Chicken Wrap', description: 'Spicy chicken wrap', price: 8.49 },
    { title: 'Mushroom Soup', description: 'Creamy mushroom soup', price: 5.99 },
    { title: 'Grilled Salmon', description: 'Salmon with lemon butter', price: 12.50 },
    { title: 'Beef Tacos', description: 'Soft tacos with seasoned beef', price: 9.99 },
    { title: 'Chicken Fried Rice', description: 'Fried rice with chicken and veggies', price: 8.99 },
    { title: 'Mozzarella Sticks', description: 'Deep-fried cheesy sticks', price: 4.99 },
    { title: 'Pancakes', description: 'Fluffy pancakes with syrup', price: 5.50 },
    { title: 'Ice Cream Sundae', description: 'Vanilla ice cream with toppings', price: 4.50 },
    { title: 'Steak Sandwich', description: 'Grilled steak in a bun', price: 10.99 },
    { title: 'Lemonade', description: 'Refreshing lemonade drink', price: 2.99 },
    { title: 'Iced Tea', description: 'Chilled sweet tea', price: 2.50 }
  ]

  items.each do |item_data|
    category = categories.sample

    Item.create!(
      title: item_data[:title],
      description: item_data[:description],
      price: item_data[:price],
      category: category,
      retired: false
    )
  end

  puts "Seeded #{items.size} items successfully!"
end
