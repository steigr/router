module Router
  class Registry
    extend Singleton
    include Logging
    log_color :green
    log_level Logger::INFO
    def callbacks
      @callbacks ||= {}
    end
    def add_callback params={}
      category = params.first.first
      cbs = params.first.last
      cbs.each do |event,callback|
        callbacks[category] ||= {}
        callbacks[category][event] ||= []
        callbacks[category][event] << callback
      end
    end
    def stores
      @stores ||= {}
    end
    def category category
      log debug: "category create #{category}" if stores[category].nil?
      stores[category] ||= {}
    end
    def store product
      add product.category, product.id, product
    end
    def add category, id, object
      bucket = category(category)
      log debug: "add #{category}/#{id} = #{object}"
      bucket[id] = object
      callback __method__, category, id, object
    end
    def drop product
      add product.category, product.id
      category(product.category).delete product.id
    end
    def replace category, id, object
      category(category)[id] = object
    end
    def remove category, id
      bucket = category(category)
      log debug: "remove #{category}/#{id}"
      callback __method__, category, id, bucket[id]
      bucket.delete id
    end
    def categories
      stores.keys
    end
    def callback event, category, id, object
      log debug: "cb? #{callbacks[category][event]}"
      callbacks = callbacks[category][event] rescue []
      callbacks.each do |callback|
        log debug: "cb #{callback}"
        callback.call(object)
      end
    end
  end
end