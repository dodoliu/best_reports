class UserActionEvent < AnalyticsBase
  self.table_name = 'UserActionEvent'
  # include SpreadsheetArchitect

  # def spreadsheet_columns
  #   [:openid, :ActionDate]
  # end

  # acts_as_xlsx


  scope :query_pv_by_day, -> { select "ActionDate as '日期',count(*) as 'pv',count(distinct OpenId) as 'uv'" }
  scope :actiontype_view, -> { where "actiontype='view'" }
  scope :appid, ->(appid){ where "appid=?",appid }
  scope :modid, ->(appid){ where "modid=?",appid % 50 }
  scope :actioncampaign, -> (campaignid){ where "ActionCampaign=?",campaignid }

  scope :createdatetime_morethen, -> (start_date){ where "CreateDateTime > ?", start_date }
  scope :createdatetime_lessthen, -> (end_date){ where "CreateDateTime <= ? ", end_date + ' 23:59:59' }

# and ActionDate > 20160905 and ActionDate < 20160912

  scope :actiondate_morethen, -> (start_date){ where "ActionDate >= ?", start_date.to_i }
  scope :actiondate_lessthen, -> (end_date){ where "ActionDate <= ? ", end_date.to_i }
  scope :actioncampaignstatus_in, ->(status){ where 'ActionCampaignStatus in (?)', status}
  scope :actioncampaignstatus_right_like, ->(status){ where 'ActionCampaignStatus like ?', "#{status}%"}
  scope :actioncampaignstatus_equal, ->(status){ where 'ActionCampaignStatus= ?', status}
  scope :actionname_equal, ->(name){ where 'actionname=?', name }
  scope :actionname_in, ->(names){ where 'actionname in (?)', names }

  scope :group_by_action_date, ->{ group "actiondate" }

  scope :query_uv_by_target, -> { select "count(distinct OpenId) as 'uv' " }




end