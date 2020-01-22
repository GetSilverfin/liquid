module Liquid
  class ResourceLimits
    attr_accessor :render_length, :render_score, :assign_score, :render_end_time,
      :render_length_limit, :render_score_limit, :assign_score_limit, :render_time_limit

    def initialize(limits)
      @render_length_limit = limits[:render_length_limit]
      @render_score_limit = limits[:render_score_limit]
      @render_time_limit = limits[:render_time_limit]
      @assign_score_limit = limits[:assign_score_limit]
      reset
    end

    def reached?
      (@render_length_limit && @render_length > @render_length_limit) ||
        (@render_score_limit && @render_score > @render_score_limit) ||
        (@assign_score_limit && @assign_score > @assign_score_limit)
    end

    def time_limit_reached?
      @render_time_limit && time > @render_end_time
    end

    def reset
      @render_length = @render_score = @assign_score = 0
      if @render_time_limit
        @render_end_time = time + @render_time_limit
      else
        @render_end_time = nil
      end
    end

    private

    def time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
