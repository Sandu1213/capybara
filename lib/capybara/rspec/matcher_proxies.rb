# frozen_string_literal: true
module Capybara
  module RSpecMatcherProxies
    def all(*args)
      if defined?(::RSpec::Matchers::BuiltIn::All) && args.first.respond_to?(:matches?)
        ::RSpec::Matchers::BuiltIn::All.new(*args)
      else
        find_all(*args)
      end
    end

    def within(*args)
      if block_given?
        within_element(*args, &Proc.new)
      else
        be_within(*args)
      end
    end
  end
end

if defined?(::RSpec::Matchers)
  module ::RSpec::Matchers
    if defined?(::RSpec::Matchers::BuiltIn::All)
      def all_with_capybara(*args)
        raise "To use Capybara's #all make sure Capybara::DSL is included after RSpec::Matchers" unless args.first.respond_to? :matches?
        all_without_capybara(*args)
      end

      alias_method :all_without_capybara, :all
      alias_method :all, :all_with_capybara
    end

    if instance_methods.include?(:within)
      def within_with_capybara(*args)
        raise "To use Capybara's #within make sure Capybara::DSL is included after RSpec::Matchers" if block_given?
        within_without_capybara(*args)
      end

      alias_method :within_without_capybara, :within
      alias_method :within, :within_with_capybara
    end
  end
end

# Alternate potential change
# module  ::RSpec::Matchers
#   def self.included(base)
#     base.send(:include, ::Capybara::RSpecMatcherProxies) if base.include?(::Capybara::DSL)
#     super
#   end
# end

