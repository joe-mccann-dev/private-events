module EventsHelper
  private
    def future_non_hosted_event?(event)
      Event.upcoming.include?(event) && current_user != event.host
    end

    def current_user_is_host?
      current_user == @event.host
    end

    def future_time_in_days(event)
      pluralize(((event.start_time - Time.zone.now)/86400).round, 'day')
    end

    def days_since_invitation_sent(invitation)
      pluralize(((Time.zone.now - invitation.created_at)/86400).round, 'day')
    end

    def current_user_hosts_upcoming_event?(event)
      event.host == current_user && Event.upcoming.include?(event)
    end
end
