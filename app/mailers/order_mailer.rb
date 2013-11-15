# encoding: utf-8
class OrderMailer < ActionMailer::Base
  default from: PasherConfig::CONFIG[:emails][:pasher]

  def new_order_email(creator, order)
    @creator = creator
    @order = order
    mail(to: PasherConfig::CONFIG[:emails][:users], subject: "#{creator.name} chce zamówić paszę w #{order.name} o #{order.ordered_at}")
  end

  def executor_email(executor_email, order)
    @order = order
    mail(to: executor_email, subject: 'Zostałeś egzekutorem - dzwoń po paszę!')
  end
end
