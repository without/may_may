module MayMay
  class ::May
    def self.permissions_setup(&block)
      instance_eval(&block) if block
    end

    def self.may(actions, options = {}, &permission_block)
      actions = [actions] unless actions.respond_to? :each
      actions.each do |action|
        define_singleton_method(get_permission_method(action, @controller)) do |contr, &block|
          allowed = if only_roles = options[:only]
            has_role?(contr, only_roles)
          elsif except_roles = options[:except]
            !has_role?(contr, except_roles)
          elsif permission_block
            has_block_permission?(contr, &permission_block)
          else
            true # may :index # action permitted without exceptions
          end
          block.call if allowed && block
          allowed
        end
      end
    end

    def self.permission_to?(action_name, controller_name, contr, &block)
      method = get_permission_method(action_name, controller_name)
      respond_to?(method) && send(method, contr, &block)
    end

    def self.has_role?(contr, roles)
      roles = [roles] unless roles.respond_to? :include?
      contr.current_roles.each {|role| return true if roles.include?(role) }
      false
    end

    def self.get_permission_method(action_name, controller_name)
      "#{action_name}_#{controller_name}?"
    end

    private

    def self.controller(contr)
      old_controller = @controller
      @controller = contr
      yield if block_given?
      @controller = old_controller
    end

    def self.has_block_permission?(contr, &block)
      block.call(contr)
    end
  end

  module MayMayACExtensions
    def self.setup(klass)
      klass.before_filter :may_may_setup
      klass.helper_method :may?
    end

    def access_denied
      response.status = 403
      render :text => 'Access Denied'
    end

    def current_roles
      []
    end

    def may?(action_name, controller_name, &block)
      May.permission_to?(action_name, controller_name, self, &block)
    end

    private

    def may_may_setup
      May.permissions_setup
      access_denied unless May.permission_to? params[:action], params[:controller], self
    end
  end

  class ActionController::Base
    include MayMayACExtensions
    MayMayACExtensions.setup(self)
  end
end
