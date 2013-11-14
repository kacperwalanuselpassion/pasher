# encoding: utf-8
class OrderMailer < ActionMailer::Base
  default from: 'elpasher@elpassion.com'

  def new_order_email(creator, order)
    @creator = creator
    @order = order
    mail(to: PasherConfig::CONFIG[:emails][:users], subject: "#{creator.name} chce zamówić paszę w #{order.name} o #{order.ordered_at}")
  end
end
