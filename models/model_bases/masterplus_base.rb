class MasterplusBase < ActiveRecord::Base  
  sqlserver_config = YAML::load File.open(ROOT_PATH + 'configs/sqlserver.yml')
  establish_connection sqlserver_config["MasterPlus"]
  self.abstract_class = true
end