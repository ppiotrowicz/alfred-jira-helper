module PrettyDate
  def self.format(time)
    a = (Time.now - time).to_i

    case a
    when 0 then 'just now'
    when 1 then 'a second ago'
    when 2..59 then a.to_s + ' seconds ago'
    when 60..119 then 'a minute ago' # 120 = 2 minutes
    when 120..3_540 then (a / 60).to_i.to_s + ' minutes ago'
    when 3_541..7_100 then 'an hour ago' # 3_600 = 1 hour
    when 7_101..82_800 then ((a + 99) / 3_600).to_i.to_s + ' hours ago'
    when 82_801..172_000 then 'a day ago' # 86_400 = 1 day
    when 172_001..518_400 then ((a + 800) / (60 * 60 * 24)).to_i.to_s + ' days ago'
    when 518_400..1_036_800 then 'a week ago'
    else ((a + 180_000) / (60 * 60 * 24 * 7)).to_i.to_s + ' weeks ago'
    end
  end
end
