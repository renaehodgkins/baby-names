module NamingTogether
  module ApplicationHelper
    def voted_for?(name)
      return false unless name.votes.size > 0
      name.votes.first(:ip => @env['REMOTE_ADDR']) ? true : false
    end

    def clearfix
      "<div class='clearfix'></div>"
    end

    def error_messages_for(model)
      return unless model.errors
      puts model.errors.inspect
      errors = model.errors.full_messages.collect {|message| "<p>#{message}</p>"}.join(" ")
      "<div id='errors'>#{errors}</div>"
    end

    def cycle(*items)
      @_cycle_reset = items
      @_cycle ||= items
      @_cycle.push @_cycle.shift
      @_cycle.first
    end

    def reset_cycle
      @_cycle = @_cycle_reset
    end

    def pluralize(num, word)
      return "1 #{word}" if num == 1
      [num, word.pluralize].join(' ')
    end

    def list_owner?
      logged_in? && current_user.lists.include?(@list)
    end
  end
end
