#不知为何,死活无法连接master库,只能通过sql直接查
class MasterBase < ActiveRecord::Base
  sqlserver_config = YAML::load File.open(ROOT_PATH + 'configs/sqlserver.yml')
  establish_connection sqlserver_config['Master']
  self.abstract_class = true
end