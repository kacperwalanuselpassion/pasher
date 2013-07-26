require 'spec_helper'

describe OrdersController do

  context 'CREATE order' do

    it 'creates order from params' do
      Storage::Order.should_receive(:save)
      post 'create', order: {name: 'dupa'}
    end

  end
end
