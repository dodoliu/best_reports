require 'axlsx'

class ExcelHelper
  class << self
    # #这个 write_data_to_excel的一个demo
    # def write_array_to_excel_demo
    #   tb = TableInfo.new
    #   tb.path = File.join(File.dirname(Dir.pwd),'best_reports/reports/demo.xlsx')
    #   st_array = []
    #   st = SheetInfo.new
    #   st.sheet_name = 'my name is sheet 1'
    #   st.sheet_titles = [['日期','一层信息完善人数',nil,nil,nil,nil,'二层信息完善人数'],[nil,'a','b','c','d','e','f','g','h','j','k']]
    #   st.data = [['2016-11-7',1,2,3,4,5,6,7,8,9,10],['2016-11-8',1,2,3,4,5,6,7,8,9,10],['2016-11-9',1,2,3,4,5,6,7,8,9,10],['2016-11-10',1,2,3,4,5,6,7,8,9,10]]
    #   st.merge_cells = ['A1:A2','B1:F1','G1:K1']
    #   st_array << st

    #   st = SheetInfo.new
    #   st.sheet_name = 'my name is sheet 2'
    #   st.sheet_titles = [['日期2','一层信息完善人数2',nil,nil,nil,nil,'二层信息完善人数2'],[nil,'a_1','b_1','c_1','d_1','e_1','f_1','g_1','h_1','j_1','k_1']]
    #   st.data = [['2016-12-7',1,2,3,4,5,6,7,8,9,10],['2016-12-8',1,2,3,4,5,6,7,8,9,10],['2016-12-9',1,2,3,4,5,6,7,8,9,10],['2016-12-10',1,2,3,4,5,6,7,8,9,10]]
    #   st.merge_cells = ['A1:A2','B1:F1','G1:K1']
    #   st_array << st
    #   tb.sheetinfo_array = st_array

    #   write_data_to_excel tb
    # end

    #si_array: SheetInfo的数组
    #不支持自定义表头格式
    def write_data_to_excel(tableinfo)
      @p = Axlsx::Package.new
      tableinfo.sheetinfo_array.each do |si|
        @p.workbook.add_worksheet(:name => si.sheet_name) do |sheet|
          title_style = sheet.styles.add_style(:border=>Axlsx::STYLE_THIN_BORDER,:alignment => {:horizontal => :center})
          #添加表头
          si.sheet_titles.each { |st| sheet.add_row st, :style => title_style } if si.sheet_titles.size > 0
          #填充数据
          si.data.each { |sd| sheet.add_row sd } if si.data.size > 0
          #合并单元格
          si.merge_cells.each { |sm|  sheet.merge_cells sm } if si.merge_cells.size > 0
        end
      end
      @p.serialize tableinfo.path
    end

  end
end

#整个table对象
class TableInfo
  attr_accessor :path, :sheetinfo_array
  def initialize
    @sheetinfo_array = []
  end
end

#单个sheet对象
class SheetInfo
  #begin
  #sheet_name: string 名称
  #sheet_titles: array 表头
  #merge_cells: array 需要合并的单元格,直接用物理格标记
  #data: array 需要填充的数据,data是个数组,data的每一项也是个数组(一维数组)
  #end
  attr_accessor :sheet_name, :sheet_titles, :merge_cells, :data
  def initialize
    @sheet_titles = []
    @merge_cells = []
    @data = []
  end
end