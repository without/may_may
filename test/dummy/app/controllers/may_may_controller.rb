class MayMayController < ApplicationController
  def current_roles
    r = if p_roles = params[:roles]
      p_roles.map {|role| role.to_sym }
    else
      []
    end
    return r
  end

  def index
    render :layout => false, :inline => %{<% may?(:edit, :may_may) do -%>
  Edit link
<% end -%>
}
  end
end
