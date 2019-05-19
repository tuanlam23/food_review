def create_categories
  Category.create(name: 'Quán ăn')
  Category.create(name: 'Café/Dessert')
  Category.create(name: 'Ăn vặt/Vỉa hè')
  Category.create(name: 'Tiệm bánh')
  Category.create(name: 'Trà sữa')
  Category.create(name: 'Ăn chay')
end
create_categories