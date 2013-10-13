=begin 

def MyThing
  attr_reader :sprockets

  SCORE_WEIGHTS = {       
    sprockets: {weight: 30, thresholds: Proc.new(val){ val } }
  }
  

  def initialize(sprocket_num)
    @sprockets = sprocket_num
  end
end



@object = MyThing.new(50)

calc = IqScore::Calc.new(@object)
calc.total

=end


module IqScore
  class Calc

    attr_reader :data_object, :calculations_list, :weights_list


    def initialize(d_object)
      @data_object = d_object
      set_config(@data_object)
    end


    # returns a Hash
    def calculate_metrics
      metric_vals = metrics.reduce({}) do |hsh, metric|
        hsh[metric] = @data_object.send("#{metric}")
        
        hsh
      end

      return metric_vals
    end


    # returns a Hash
    def calculate_thresholds
      thresholded_metrics = calculate_metrics

      thresholded_metrics.each_pair do |metric_name, metric_value|

        thresholds = get_thresholds_for(metric_name)
        
        if thresholds.is_a?(Proc)

          thresholded_metrics[metric_name] = thresholds.call(metric_value) 
        
        elsif thresholds.is_a?(Hash) # go to our hash of funky ranges
          if matched_threshold = find_matching_threshold(thresholds, metric_value)
            thresholded_metrics[metric_name] = matched_threshold[1]
          else
            thresholded_metrics[metric_name] = 0
          end
        end


      end

      return thresholded_metrics
    end


    def calculate_weights
      weighted_vals = self.calculate_thresholds

      @calculations_list.each_key do |key|
        weight_factor = get_weight_for(key)
        
        weighted_vals[key] *= weight_factor
      end

      weighted_vals
    end


    def calculate_total
      weighted_metrics = self.calculate_weights

      total = weighted_metrics.values.reduce(0) do |x, value|
        x += value
      end

      return total
    end


    private

    def metrics
      @calculations_list.keys
    end



    # returns either a score or nil
    def find_matching_threshold(thresholds, metric_value)



      matched_threshold = thresholds.find do |(threshold, score)|
        if threshold.is_a?(Range)
          # (0..99).include?(score)

          threshold.include?(metric_value)         ## true/false
        elsif threshold.is_a?(String)
          # "..99"
          if threshold =~ /^\.{2}(\d+)$/

            metric_value <= $1.to_i                ## true/false
          elsif threshold =~ /^(\d+)\.{2}$/
            # "10000.."
            metric_value >= $1.to_i                ## true/false
          else
            raise ArgumentError, "#{threshold} is not an acceptable format"
          end #### end threshold.is_a? String          
        end
      end  ####  end of find

      return matched_threshold
    end



    def get_weight_for(some_key)
      @calculations_list[some_key][:weight]
    end

    def get_thresholds_for(some_key)
      thresholds = @calculations_list[some_key][:thresholds]
    end


    def set_config(dobj)
      @calculations_list = dobj.class::SCORE_WEIGHTS     
    end



  end
end