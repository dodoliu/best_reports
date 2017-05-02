#会员专享礼已消耗的奖券信息,
require File.expand_path("../..") + '/base_main.rb'

class MemberGift
  # @@begin_date, @@end_date = '2016-10-20', '2017-01-19'
  # @@begin_date, @@end_date = '2016-12-07', '2016-12-11'
  # @@begin_date, @@end_date = '2016-12-14', '2016-12-19'
  # @@begin_date, @@end_date = '2016-12-19', '2016-12-26'
  # @@begin_date, @@end_date = '2016-12-26', '2017-01-02'
  # @@begin_date, @@end_date = '2017-01-09', '2017-01-16'
  # @@begin_date, @@end_date = '2017-01-15', '2017-02-06'
  # @@begin_date, @@end_date = '2017-02-05', '2017-02-13'
  # @@begin_date, @@end_date = '2017-02-12', '2017-02-20'
  # @@begin_date, @@end_date = '2017-02-20', '2017-02-27'
  # @@begin_date, @@end_date = '2017-02-27', '2017-03-06'
  # @@begin_date, @@end_date = '2017-03-06', '2017-03-13'
  # @@begin_date, @@end_date = '2017-03-13', '2017-03-20'
  # @@begin_date, @@end_date = '2017-03-20', '2017-03-27'
  # @@begin_date, @@end_date = '2017-03-27', '2017-04-05'
  # @@begin_date, @@end_date = '2017-04-05', '2017-04-10'
  # @@begin_date, @@end_date = '2017-04-10', '2017-04-17'
  @@begin_date, @@end_date = '2017-04-17', '2017-04-24'
  
  def export
    sql_comm = %q{
      SELECT [PrizeCode] as '券码',[PrizeUseTime] as '发放时间',[PrizeOpenID] as 'openid',B.Mobile  as '手机号',[PrizeValidDate] as '过期时间'  FROM [socialedplugin].[dbo].[Comm_PrizeItem] A  inner join  [socialedplugin].[dbo].[Comm_Member] B on A.PrizeOpenID = B.OpenId and B.AppId = 90 and B.Status>0  where A.appid = 90 and CampaignID = %s and  PrizeType = %s  and PrizeOpenID <> '' and A.PrizeStatus>0  and [PrizeUseTime] >= '%s' and [PrizeUseTime]< '%s' order by [PrizeUseTime]
    }

    sql_jd = sql_comm % [145, 3, @@begin_date, @@end_date]
    sql_child = sql_comm % [145, 4, @@begin_date, @@end_date]
    sql_vip = sql_comm % [127, 1, @@begin_date, @@end_date]  

    jd_data = CommPrizeItem.find_by_sql sql_jd
    child_data = CommPrizeItem.find_by_sql sql_child
    vip_data = CommPrizeItem.find_by_sql sql_vip
    
    file_path = ROOT_PATH + "reports/member_gift_detail_#{Time.now.year}_#{Time.now.month}_#{Time.now.day}.xlsx"

    tb = TableInfo.new
    tb.path = file_path

    st = SheetInfo.new
    st.sheet_name = '优惠券和vip码的中奖情况'
    st.sheet_titles = [['京东',nil,nil,nil,nil,'孩子王',nil,nil,nil,nil,'vip',nil,nil,nil,nil],['券码', '发放时间', 'openid', '手机号', '过期时间','券码', '发放时间', 'openid', '手机号', '过期时间','券码', '发放时间', 'openid', '手机号', '过期时间']]    
    st.merge_cells = ['A1:E1','F1:J1','K1:O1']

    sheet_data = Array.new
    each_count = [jd_data.length,child_data.length,vip_data.length].max
    (0..each_count).each do |index|
      tmp_data_array = []
      push_data_check index, jd_data, tmp_data_array
      push_data_check index, child_data, tmp_data_array
      push_data_check index, vip_data, tmp_data_array
      sheet_data << tmp_data_array
    end
    st.data = sheet_data
    st_array = []
    st_array << st
    tb.sheetinfo_array = st_array
    ExcelHelper.write_data_to_excel tb
    MailHelper.new.send_mail 'ray.zhang@teein.com,dongyue.liu@teein.com', '会员专享礼数据报表', '数据见附件', file_path
  end

  private
    def push_data_zero(tmp_data)
      tmp_data.push 0
      tmp_data.push 0
      tmp_data.push 0
      tmp_data.push 0
      tmp_data.push 0
    end
    def push_data_no_zero(tmp_data,code,use_date,openid,mobile,expires_date)
      # puts use_date
      # puts expires_date
      tmp_data.push "'" + code
      tmp_data.push use_date
      tmp_data.push openid
      tmp_data.push mobile
      tmp_data.push expires_date
    end
    def push_data_check(index,target_data,tmp_data_array)
      if index <= (target_data.length - 1)
        push_data_no_zero tmp_data_array,target_data[index].券码,target_data[index].发放时间,target_data[index].openid,target_data[index].手机号,target_data[index].过期时间           
      else
        push_data_zero tmp_data_array
      end
    end
    #查未过期的京东,孩子王,vip券的使用情况
    def no_past_due_data
      sql = ""
    end
end

if !ARGV.empty?
  MemberGift.new.send ARGV[0]
else
  puts '没接收任何输入,无方法被调用!'
end

#调用示例
#导出数据
#ruby member_gift.rb export