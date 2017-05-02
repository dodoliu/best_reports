#膳食小助手数据报表
require File.expand_path("../..") + '/base_main.rb'

class Assistant
  #使用时间,openid、首次使用时间、宝宝生日或预产期(首次使用时间重复出现)
  @@begin_date, @@end_date = 20161201,20161207

  def export
    sql_a = %q{
      select A.[date] as '使用时间',A.OpenID as 'OpenID', case B.membertype when '备孕' then '准备' when '怀孕' then '已孕' when '宝妈' then '已产' else '其它' end as '阶段',B.Company as '出生日期或预产期' from aptamil_dailyscore A left join Comm_Member B on A.OpenID = B.OpenID where A.date >= %s and A.date <= %s
    }

    sql_b = %q{
      select a.openid as 'OpenID',a.[date] as '首次使用时间' from Aptamil_DailyScore a where 1 > (select count(*) from Aptamil_DailyScore where OpenID = a.OpenID and [date] < a.[date] ) and a.date >= %s and a.date <= %s order by a.OpenID
    }

    a_data = CommMember.find_by_sql sql_a % [@@begin_date, @@end_date]
    b_data = CommMember.find_by_sql sql_b % [@@begin_date, @@end_date]

    file_path = ROOT_PATH + "reports/assistant_#{Time.now.year}_#{Time.now.month}_#{Time.now.day}.xlsx"
    
    tb = TableInfo.new
    st_array = []
    tb.path = file_path 

    st = SheetInfo.new
    st.sheet_name = '使用明细'
    st.sheet_titles = [['使用时间','OpenID','阶段','出生日期或预产期']]
    sheet_data = Array.new
    a_data.each do |row|
      tmp_array = []
      tmp_array.push row.使用时间
      tmp_array.push row.OpenID
      tmp_array.push row.阶段
      tmp_array.push row.出生日期或预产期
      sheet_data << tmp_array
    end
    st.data = sheet_data
    st_array << st

    st_other = SheetInfo.new
    st_other.sheet_name = '首次使用时间'
    st_other.sheet_titles = [['OpenID','首次使用时间']]
    sheet_data_other = Array.new
    b_data.each do |row|
      tmp_array = []
      tmp_array.push row.OpenID
      tmp_array.push row.首次使用时间
      sheet_data_other << tmp_array
    end
    st_other.data = sheet_data_other
    st_array << st_other

    tb.sheetinfo_array = st_array
    ExcelHelper.write_data_to_excel tb    
    MailHelper.new.send_mail 'dongyue.liu@teein.com', '膳食小助手数据报表', '数据见附件', file_path
  end
end


if !ARGV.empty?
  Assistant.new.send ARGV[0]
else
  puts '没接收任何输入,无方法被调用!'
end

#调用示例
#导出数据
#ruby assistant.rb export
