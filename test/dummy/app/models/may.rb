class May
  May.permissions_setup do
    controller :may_may do
      may :index, only: [:index_role, :edit_role]
      may :edit, only: [:edit_role]
    end
  end
end
