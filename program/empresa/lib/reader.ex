defmodule Reader do

  alias Empresa.Empleado, as: Emp

  def read_empleados(nombreArchivo \\ "empleados.json") do
    case File.read(nombreArchivo) do
      {:ok, contents} -> Jason.decode!(contents, keys: :atoms)
      |> Enum.map(fn empleado_map -> struct(Emp, empleado_map) end)
      {:error, :enoent} -> []
    end
  end

  def read_empleados_func(nombreArchivo \\ "empleados.json") do
    case File.read(nombreArchivo) do
      {:ok, contents} ->
        empleados =
          contents
          |> Jason.decode!(keys: :atoms)
          |> Enum.map(fn empleado_map -> struct(Emp, empleado_map) end)
        {:ok, empleados}
      {:error, :enoent} -> {:ok, []}
      {:error, reason} -> {:error, reason}
    end
  end

  def search_empleados_by_name(name, nombreArchivo  \\ "empleados.json" ) do
    case read_empleados_func(nombreArchivo) do
      {ok, contents} -> Enum.filter(contents, fn emp -> emp.name == name end)
      {:error, :enoent} -> []
    end
  end

  def search_empleados_by_name2(name, nombreArchivo  \\ "empleados.json" ) do
    empleados = read_empleados(nombreArchivo)
    empleados_find = Enum.filter(empleados, fn emp -> emp.name == name end)
    empleados_find
  end

end
