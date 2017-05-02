#引用所有对象,其它继承该类
require 'yaml'
require 'active_record'
require 'logger'
require 'require_all'

#设置activerecord的时间时区,不设置,默认为utc
ActiveRecord::Base.default_timezone = :local

ROOT_PATH = File.expand_path("../..") + "/"
ActiveRecord::Base.logger = Logger.new(File.open(ROOT_PATH + "logs/database_#{Time.now.year}#{Time.now.month}#{Time.now.day}.log",'a'))
require_all ROOT_PATH + 'models'
require_all ROOT_PATH + 'helpers'