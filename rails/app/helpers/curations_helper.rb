module CurationsHelper
  def exact_time(seconds)
    statement = ""
    time_set = []
    time_set << seconds/1.week
    seconds = seconds-time_set.last.weeks
    time_set << seconds/1.day
    seconds = seconds-time_set.last.days
    time_set << seconds/1.hour
    seconds = seconds-time_set.last.hours
    time_set << seconds/1.minute
    seconds = seconds-time_set.last.minutes
    time_set << seconds
    ordered_set = ["Weeks", "Days", "Hours", "Minutes", "Seconds"]
    i = 0
    time_set.each do |t|
      if t == 1
        statement << "#{t} #{ordered_set[i].chop}, "
      elsif t != 0
        statement << "#{t} #{ordered_set[i]}, "
      end
      i+=1
    end
    return statement.chop.chop
  end
  
  def current_status(curation)
    ["tsv_storing", "tsv_stored", "needs_import", "imported", "live", "needs_drop", "dropped"]
    if curation.status == "tsv_storing"
    elsif curation.status == "tsv_stored"
    elsif curation.status == "needs_import"
    elsif curation.status == "imported"
    elsif curation.status == "live"
    elsif curation.status == "needs_drop"
    elsif curation.status == "dropped"
    end
  end
end
