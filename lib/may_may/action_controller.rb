module MayMay
  module MayMayACExtensions
    module ClassMethods
      def may_control_access(params = {})
        return control_access unless (only = params[:only]) || (except = params[:except])
        controller_name = fix_controller_name name
        if only
          only = [only] unless only.respond_to? :include?
          control_access if only.include? controller_name
        end
        if except
          Rails.logger.debug "except: #{except}"
          except = [except] unless except.respond_to? :include?
          control_access unless except.include? controller_name
        end
      end

      def may(action_name, options, &block)
        May.controller(fix_controller_name(name)) { May.may action_name, options, &block }
      end

      def fix_controller_name(controller_name)
        controller_name.gsub(/Controller$/, '').tableize
      end

      def control_access
        before_filter :may_may_setup
      end
    end

    def self.setup(klass)
      klass.extend(MayMayACExtensions::ClassMethods)
      klass.helper_method :may?
      klass.helper_method :has_role?
    end

    def access_denied
      response.status = 401
      if Rails.env == 'development'
        render_text = "Permission denied to action :#{params[:action]} on controller :#{params[:controller]}"
        if May.respond_to? get_permission_method
          render text: render_text
        else
          render_text = '<h1>' + render_text + '</h1>' + %{
            <p>Controller action permission needs to be specified in your May model. Example:</p>

            <pre>
            # in app/models/may.rb:

            class May
              controller :#{params[:controller]} do
                may :#{params[:action]}, only: [:role_1, :role_2]
              end
            end
            </pre>

            <p>For more detailed information, view the <a href="https://github.com/without/may_may/blob/master/README.md">MayMay gem's README.md</a></p>
          }
          render layout: false, inline: render_text
        end
      else
        render text: "Access Denied."
      end
    end

    def current_roles
      (respond_to?(:current_user) && current_user.respond_to?(:role_names)) ? current_user.role_names : []
    end

    def may?(action_name, controller_name, &block)
      May.permission_to?(action_name, controller_name, self, &block)
    end


    def has_role?(role)
      May.has_role?(self, role)
    end

    private

    def get_permission_method
      May.get_permission_method params[:action], params[:controller].to_s.pluralize.to_sym
    end

    def may_may_setup
      method = get_permission_method
      access_denied unless May.respond_to?(method) && May.send(get_permission_method, self)
    end
  end

  if defined? ActionController::Base
    ActionController::Base.class_eval do
      include MayMayACExtensions
      MayMayACExtensions.setup(ActionController::Base)
    end
  end
end