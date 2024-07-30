defmodule Empresa do

   defmodule Empleado do
     #Declarar parametros obligatorios
     @enforce_keys [:name, :position]
     #Le dice como va a realizar el mapeo a un Json
     @derive {Jason.Encoder, only: [
      :id,
      :name,
      :position,
      :email,
      :phone,
      :hire_date,
      :salary
     ]}
     defstruct [:id, :name, :position, :email, :phone, :hire_date, :salary]

     #Declara tipos para la estructura
     @type t :: %__MODULE__{
       id:        integer()  | nil,
       name:      String.t(),
       position:  String.t(),
       email:     String.t() | nil,
       phone:     String.t() | nil,
       hire_date: Date.t()   | nil,
       salary:    float()    | nil
     }

     def new(name, position, options \\ []) do
       struct(__MODULE__, [name: name, position: position] ++ options)
     end
   end
end
