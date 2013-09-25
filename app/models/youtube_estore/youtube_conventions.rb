require 'aggtive_record'

module YoutubeEstore
  module YoutubeConventions        
    extend ActiveSupport::Concern
   

    include AggtiveRecord::Aggable


    module ClassMethods
      def add_sorted_value_and_sort(foo, opts={})
        arr = sort_by_sorted_value(foo, opts)
        add_sorted_value(arr, foo)
      end

      def sort_by_sorted_value(foo, opts)
        if foo.class == Proc 
          self.all.sort_by { |c| -foo.call(c) }
        else
          order_val = opts[:order] || 'DESC'
          self.order("#{foo} #{order_val}")
        end
      end

      def add_sorted_value(arr, foo)
        arr.each do |channel|  
          if foo.class == Proc
            x = foo.call(channel)
            channel.instance_eval "def sorted_value; #{x}; end"
          else
            channel.instance_eval "def sorted_value; #{channel.send(foo)}; end"
          end
        end

        arr
      end
    end



    included do 
      validates_presence_of :t_id
    end


    def timestamp_attributes_for_create
      super << :rails_created_at
    end


    def timestamp_attributes_for_update
      super << :rails_updated_at
    end



  end
end