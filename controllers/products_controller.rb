module ProductsController
  def products_index_action
    product_hashs = get_request("/products")
    products = Product.convert_hashs(product_hashs)

    products_index_view(products)
  end

  def products_show_action
    input_id = products_id_form

    product_hash = get_request("/products/#{input_id}")
    product = Product.new(product_hash)

    products_show_view(product)

    puts "Press enter to continue or type 'o' to order"
    user_choice = gets.chomp 
    if user_choice == 'o'
      print "Enter a quanity to order: "
      input_quantity = gets.chomp
      client_params = {

                        quaintity: input_quantity, 
                        product_id: input_id
                      }
      # json_data = post_request("/order", client_params)
      response = Unirest.post("http://localhost:3000/orders", parameters: client_params)
      if response.code == 200
      puts JSON.pretty_generate(response.body)
      elsif response.code == 401
        puts "Nope, try logging in first"
      end 
    end 
  end

  def products_create_action
    client_params = products_new_form
    response = Unirest.post("http://llcalhost:3000/products", parameters: client_params)

    if response == 200
      product = Product.new(response.body)
      products_show_view(product)
    

    elsif response.code == 422
      errors = response.body["errors"]
      products_errors_view(errors)
    elsif response.code == 401
      puts JSON.pretty_generate(response.body)
    end
  end

  def products_update_action
    input_id = products_id_form
    product_hash = get_request("/products/#{input_id}")
    product = Product.new(product_hash)

    client_params = products_update_form(product)


    client_params = products_update_form(product)

    # json_data = patch_request("/products/#{input_id}", client_params)

    response = Unirest.post("http://localhost:3000/products", parameters: client_params)

    if response.code == 200
      product = Product.new(response.body)
      products_show_view(product)
    elsif response.code == 422
      errors = response.body["errors"]
      products_errors_view(errors)
    elsif response.code == 401
      puts JSON.pretty_generate(response.dody)
    end
  end


  def products_destroy_action
    input_id = products_id_form
    json_data = delete_request("/products/#{input_id}")
    puts json_data["message"]
    # response = Unirest.delete("http://localhost:3000/products/#{input_id}")
    # if response.code == 200
    #   puts response.body["message"]
    # else response.code == 422
    #   errors = json_data["errors"]
    #   products_errors_view(errors)
    # elsif response code == 421
    #   puts JSON.pretty_generate(response.body)
    # end
    # # puts json_data["message"]
  end

  def products_search_action
    print "Enter a name to search by: "
    search_term = gets.chomp

    product_hashs = get_request("/products?search=#{search_term}")
    products = Product.convert_hashs(product_hashs)

    products_index_view(products)
  end

  def products_sort_action(attribute)
    product_hashs = get_request("/products?sort=#{attribute}")
    products = Product.convert_hashs(product_hashs)

    products_index_view(products)
  end
end




  
  

  
  

 

