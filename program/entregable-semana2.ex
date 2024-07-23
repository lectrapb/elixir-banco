defmodule LibraryManager do
  defstruct books: [], users_library: []

  # Gestión de Libros
  def add_book(%LibraryManager{books: books} = library_manager, name, stock) do
    id = Enum.count(books) + 1
    book = %{isbn: id, name: name, stock: stock}
    %{library_manager | books: books ++ [book]}
  end

  def list_books(%LibraryManager{books: books}) do
    IO.puts("***********      Books   ********************")
    IO.puts("isbn | book_name  | book_quantity")
    Enum.each(books, fn book ->
      IO.puts("#{book.isbn} | #{book.name} | #{book.stock}")
    end)
  end

  def check_availability(%LibraryManager{books: books}, isbn) do
    case Enum.find(books, fn book -> book.isbn == isbn end) do
      nil ->
        IO.puts("The book with ISBN #{isbn} is not available in the library.")

      %{isbn: isbn, name: name, stock: stock} ->
        IO.puts("***********      Book Availability   ********************")
        IO.puts("isbn | book_name  | book_quantity")
        IO.puts("#{isbn} | #{name} | #{stock}")
    end
  end

  def register_user(%LibraryManager{users_library: users_library} = library_manager, name) do
    id = Enum.count(users_library) + 1
    user = %{id: id, name: name}
    %{library_manager | users_library: users_library ++ [user]}
  end

  def list_users(%LibraryManager{users_library: users_library}) do
    IO.puts("***********      Users   ********************")
    IO.puts("id | user_name")
    Enum.each(users_library, fn user ->
      IO.puts("#{user.id} | #{user.name}")
    end)
  end

  def lend_book(%LibraryManager{books: books} = library_manager, isbn) do
    case Enum.find_index(books, fn book -> book.isbn == isbn end) do
      nil ->
        IO.puts("The book with ISBN #{isbn} is not available in the library.")
        library_manager

      index ->
        case Enum.at(books, index) do
          %{stock: 0} ->
            IO.puts("The book with ISBN #{isbn} is currently out of stock.")
            library_manager

          book ->
            updated_book = %{book | stock: book.stock - 1}
            updated_books = List.replace_at(books, index, updated_book)
            IO.puts("The book with ISBN #{isbn} has been lent out. Remaining stock: #{updated_book.stock}")
            %{library_manager | books: updated_books}
        end
    end
  end

  def run do
    library_manager = %LibraryManager{}
    loop(library_manager)
  end

  defp loop(library_manager) do
    IO.puts("""
    Library Manager
    1. Add book
    2. List books
    3. Check Availability
    4. Register User
    5. List Users
    6. Lend Book
    7. Exit
    """)

    IO.write("Choose an option: ")
    option = IO.gets("") |> String.trim() |> String.to_integer()

    case option do
      1 ->
        IO.puts("Enter the name of the book")
        name = IO.gets("") |> String.trim()
        IO.puts("Enter the stock of the book")
        stock = IO.gets("") |> String.trim() |> String.to_integer()
        library_manager = add_book(library_manager, name, stock)
        loop(library_manager)

      2 ->
        list_books(library_manager)
        loop(library_manager)

      3 ->
        IO.puts("Enter the ISBN code to check availability")
        isbn = IO.gets("") |> String.trim() |> String.to_integer()
        check_availability(library_manager, isbn)
        loop(library_manager)

      4 ->
        IO.puts("Enter the name of the user")
        name = IO.gets("") |> String.trim()
        library_manager = register_user(library_manager, name)
        loop(library_manager)

      5 ->
        list_users(library_manager)
        loop(library_manager)

      6 ->
        IO.puts("Enter the ISBN code of the book to lend")
        isbn = IO.gets("") |> String.trim() |> String.to_integer()
        library_manager = lend_book(library_manager, isbn)
        loop(library_manager)

      7 ->
        IO.puts("¡Bye!")
        :ok

      _ ->
        IO.puts("Option not allowed")
        loop(library_manager)
    end
  end
end

# Ejecutar el control de inventarios
LibraryManager.run()
