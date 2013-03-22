module MayMay
  class ::May
    def self.may(actions, options = {}, &permission_block)
      actions = [actions] unless actions.respond_to? :each
      actions.each do |action|
        define_singleton_method(get_permission_method(action, @controller)) do |contr, &block|
          allowed = (only_roles = options[:only]) ? has_role?(contr, only_roles) : true
          allowed &&= (except_roles = options[:except]) ? !has_role?(contr, except_roles) : true
          allowed &&= (method = options[:method]) ? contr.send(method) : true
          allowed &&= permission_block ? has_block_permission?(contr, &permission_block) : true
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
      "#{action_name}_#{controller_name.to_s.gsub(/\//, '_')}?".to_sym
    end

    private

    def self.controller(contr)
      old_controller = @controller
      @controller = contr
      yield if block_given?
      @controller = old_controller
    end

    def self.has_block_permission?(contr, &block)
      contr.instance_eval(&block)
    end
  end
end
