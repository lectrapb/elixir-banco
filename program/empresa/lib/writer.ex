defmodule Writer do

import Reader
 #Alias ahora es Empleado
 # El signo ! genera la traza del error
 alias Empresa.Empleado, as: Emp

  #Agrega tipos al parametro
  @spec write_empleado(Emp.t(), String.t()) :: :ok | {:error, term()}
  def write_empleado(%Emp{} = empleado, nombreArchivo \\ "empleados.json") do
    empleados = read_empleados(nombreArchivo)
    next_id = Enum.count(empleados) + 1
    empleado_new = Map.put(empleado, :id , next_id)
    empleados_new = [empleado_new | empleados]

    empleados_json = Jason.encode!( empleados_new, pretty: true)
    File.write(nombreArchivo, empleados_json)
  end

  def delete_empleado_by_id(id, nombreArchivo \\ "empleados.json" ) do
    empleados = read_empleados(nombreArchivo)
    empleados_new = Enum.reject(empleados, fn emp -> emp.id == id end)
        empleados_json = Jason.encode!( empleados_new, pretty: true)
    File.write(nombreArchivo, empleados_json)
  end

end
