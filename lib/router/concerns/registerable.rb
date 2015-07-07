module Router
  module Registerable
    module InstanceMethods
      def id id=nil
        @id ||= id
        @id ||= self.class.id
      end
      def category category=nil
        @category ||= category
        @category ||= self.class.category
      end
      def save
        Registry.replace category, id, self
      end
      def remove
        Registry.remove category, id
      end
    end
    module ClassMethods
      def id id=nil
        @id ||= id
        @id ||= self.name.split("::").last.downcase.to_sym
      end
      def category category=nil
        @category ||= category
        @category ||= self.name.split("::").last.downcase.to_sym
      end
      def save
        Registry.replace category, id, self
      end
      def create *args
        Registry.store self.new(*args)
      end
      def remove
        Registry.remove category, id
      end
    end
    def self.included base
      base.send :extend, Router::Registerable::ClassMethods
      base.send :include, Router::Registerable::InstanceMethods
    end
  end
end