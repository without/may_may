class May
  May.permissions_setup do
    controller :may_may do
      may :index
      may :new, only: [:standard]
      may :show, except: [:admin]
      may :edit, only: [:admin]
      may(:destroy) {|controller| has_role? controller, :admin }
    end
  end
end
