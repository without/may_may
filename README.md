# MayMay

## Installation

gem install may_may

## Usage

MayMay automatically restricts access to actions on all controllers and then allows you to specify
permitted actions. Because an action is restricted by default, you will never accidentally allow all
users access to a new action that should have been restricted. Permitted actions are all listed in
one place (a May model) for ease of maintenance.

### No need to name roles in your views

Simplify your views. Show/hide view elements based on intended action instead of current user's roles:

    <% may? (:edit, :people) do %>
      <%= link_to 'only visible if user may edit people', edit_people_path %>
    <% end %>

### Create a model named "may":

    # in app/models/may.rb

    class May
      May.permission_setup do
        controller :people do
          may :index # anyone can execute the index action
          may :create, :only => [:administrator] # only the administrator may create a person
          may :edit, :except => [:guest] # everyone except guests may edit a person
          may [:new, :update] do
            # return true to allow these actions
            # block executed in controller's scope
          end
        end # :destroy was never mentioned and so is not permitted for anyone
      end
    end

### Add a role_names method to your User object

Here is a simple example setup:

    # in app/models/role.rb

    class Role
      # roles table should have a "name" column
    end

    # in app/models/user_role.rb

    class UserRole
      has_many :roles
    end

    # in app/models/user.rb

    class User
      has_many :user_roles
      has_many :roles, through: :user_roles

      def role_names
        roles.map {|role| role.name.to_sym }
      end
    end

    # in app/controllers/application_controller.rb

    class ApplicationController < ActionController::Base
      def current_user
        @current_user ||= User.find(session[:user_id]) rescue nil
      end

      def current_user=(value)
        value ? session[:user_id] = value.id : session.delete(:id)
        @current_user = value
      end
    end

The important thing is to return an array of roles that can be matched against the roles specified in
your May model. Your array may contain whatever types you'd like -- strings, symbols, models. Symbols
are probably most readable, however, hence the example above.

You could instead define permissions within the controller itself:

    class UsersController
      may :index, only: [:some, :roles]
      may :show, method: [:may_show?]
    end

## In more depth

MayMay adds a few methods to ActionController::Base:

*** `may` (class method)  

Define permissions in your controller instead of May model. Shortcut for `May.may(self, ...)`  

Usage:

    class SomeController < ApplicationController
      may :index, except: [:this_role]
    end

*** `current_roles`  

Returns `current_user.role_names` or empty array if `current_user` returns nil or is missing

*** `has_role?`  

Check `current_roles` for a specific role.  

Usage: if `has_role? :some_role`

*** may? (helper method)  

Check for permission to perform an action.  

Usage: if `may? :action_name, :controller_name`

## Licence

MIT-LICENSE
