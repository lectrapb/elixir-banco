defmodule InventoryManager do
    defstruct products: [], shopping_car: []


    def add_product(%InventoryManager{products: products} = product_manager, name, price, stock) do
      id = Enum.count(products) + 1
      product = %{id: id, name: name, price: price, stock: stock }
      %{product_manager | products: products ++ [product] }
    end

    def list_products(%InventoryManager{products: products}) do
      IO.puts("***********      Products1   ********************")
      IO.puts("id_product | product_name | product_price  | product_quantity")
      Enum.each(products, fn product ->
        formatted_price = Float.to_string(product.price, decimals: 2)
        IO.puts("#{product.id}| #{product.name}| #{formatted_price} | #{product.stock}")
      end)
    end

    def increase_stock(%InventoryManager{products: products} = product_manager, id, quantity) do
      update_products = Enum.map(products, fn product ->
        if product.id == id do
          update_quantity = product.stock + quantity
          %{product | stock: update_quantity}
        else
          product
        end
      end)
      %{product_manager | products: update_products}
    end

    def sell_product(%InventoryManager{products: products} = product_manager, id, quantity) do
      inventory_manager = reduce_stock(product_manager, id, quantity)
      inventory_manager = add_to_shopping_car(inventory_manager, id, quantity)
    end


    def view_cart(%InventoryManager{shopping_car: shopping_car}) do
      IO.puts("***********      Shooping Car   ********************")
      IO.puts("id_product | product_name | product_price  | quantity")
      Enum.each(shopping_car, fn item ->
        formatted_price = Float.to_string(item.price, decimals: 2)
        IO.puts("#{item.id} | #{item.name} | #{formatted_price} | #{item.quantity}")
      end)
    end

    def add_to_shopping_car(%InventoryManager{products: products, shopping_car: shopping_car} = inventory_manager, product_id, quantity) do
      case Enum.find(products, fn product -> product.id == product_id end) do
        nil ->
          IO.puts("Product not found")
          inventory_manager

        product ->
          shopping_car_item = %{id: product.id, name: product.name, price: product.price, quantity: quantity}
          %{inventory_manager | shopping_car: shopping_car ++ [shopping_car_item]}
      end
    end

    def reduce_stock(%InventoryManager{products: products} = product_manager, id, quantity) do
      update_products = Enum.map(products, fn product ->
        if product.id == id do
          update_quantity = product.stock - quantity

          if update_quantity >= 0 do
            %{product | stock: update_quantity}
          else
            IO.puts("Not enought Inventory")
          end
        else
          product
        end
      end)
      %{product_manager | products: update_products}
    end


    def run do
      inventory_manager = %InventoryManager{}
      loop(inventory_manager)
    end


    defp loop(inventory_manager) do
      IO.puts("""
      Inventory administrator
      1. Add product
      2. List prouducts
      3. Increasing Stock
      4. Sell Product
      5. View Cart
      6. Exit
      """)

      IO.write("Choose an option: ")
      option = IO.gets("") |> String.trim() |> String.to_integer()

      case option do
        1 ->
          IO.puts("Put the name of the product")
          description = IO.gets("") |> String.trim()
          IO.puts("Put the price of the product")
          price = IO.gets("") |> String.trim() |> String.to_float()
          IO.puts("Put the stock of the product")
          stock = IO.gets("") |> String.trim() |> String.to_integer()
          inventory_manager = add_product(inventory_manager, description, price, stock)
          loop(inventory_manager)

        2 ->
          list_products(inventory_manager)
          loop(inventory_manager)

        3 ->
          IO.puts("Put the id that you want increase ")
          id = IO.gets("") |> String.trim() |> String.to_integer()
          IO.puts("Put the quantity that you want increase ")
          quantity = IO.gets("") |> String.trim() |> String.to_integer()
          inventory_manager = increase_stock(inventory_manager, id, quantity)
          loop(inventory_manager)

        4 ->
          IO.puts("Put the id that you want to sell ")
          id = IO.gets("") |> String.trim() |> String.to_integer()
          IO.puts("Put the quantity that you want buy ")
          quantity = IO.gets("") |> String.trim() |> String.to_integer()
          inventory_manager =  sell_product(inventory_manager, id, quantity)
          loop(inventory_manager)

        5 ->
          view_cart(inventory_manager)
          loop(inventory_manager)


        6 ->
          IO.puts("¡Bye!")
          :ok

        _ ->
          IO.puts("Option not allowed")
          loop(inventory_manager)
      end
    end

end

# Ejecutar el control de inventarios
InventoryManager.run()
