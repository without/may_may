# frozen_string_literal: true

class May
  controller :may_mays do
    may :index
    may :new, only: [:standard]
    may :show, except: [:admin]
    may :edit, only: [:admin]
    may(:destroy) { has_role? :admin }
  end
end
