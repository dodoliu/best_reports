class CommMember < MasterplusBase
  self.table_name = 'Comm_Member'

  scope :appid, -> (appid){ where 'appid=?',appid }
  
  scope :memberflag, -> { where "MemberFlag1 <> ''"}

  scope :group_by_create_date, -> { group "Substring(convert(varchar(20),CreateDate),0,9)" }
  scope :select_uv_by_day, -> { select "Substring(convert(varchar(20),CreateDate),0,9) as 'date', count(distinct OpenID) as 'uv'" }



end