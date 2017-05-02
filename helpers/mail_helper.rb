require 'mail'

class MailHelper
  @mail_config = ''
  def initialize
    @mail_config = YAML::load File.open(ROOT_PATH + 'configs/mail.yml')      
    base_config = @mail_config['mail_config']
    options = { :address              => base_config['address'],
                :port                 => base_config['port'],
                :domain               => base_config['domain'],
                :user_name            => base_config['user_name'],
                :password             => base_config['password'],
                :authentication       => base_config['authentication'],
                :enable_starttls_auto => base_config['enable_starttls_auto'] }
    Mail.defaults do
      delivery_method :smtp, options
    end
  end

  #发送邮件
  #to_obj: 发送的对象,多个用逗号分隔
  #title: 邮件标题
  #content: 邮件正文内容
  #attachment: 附件的路径
  def send_mail(to_obj,title,content,attachment)
    from_obj = @mail_config['mail_config']['user_name']
    Mail.deliver do
      to to_obj
      from from_obj
      subject title
      body content
      add_file attachment 
      charset = "UTF-8"     
      content_transfer_encoding = "8bit"
    end
  end
end