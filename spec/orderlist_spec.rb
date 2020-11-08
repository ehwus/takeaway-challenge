require 'orderlist'

describe OrderList do
  let(:item_ordered) { double :food }
  let(:order) { double :order }
  let(:order_class) { double :order_class, new: order}
  let(:kernel) { double :kernel }
  let(:menu) { double :menu }
  let(:restaurant) { double :restaurant, menu: menu }
  let(:test_list) { OrderList.new(restaurant, kernel, order_class) }

  describe "#new_order" do
    it "starts the process of taking an order, lets user immediately quit" do
      expect(order_class).to receive(:new)
      expect(kernel).to receive(:gets).and_return("quit")
      test_list.new_order
    end

    it "displays the menu when prompted, then lets user quit" do
      expect(kernel).to receive(:gets).and_return("1", "quit")
      expect(menu).to receive(:display_all)
      test_list.new_order
    end

    it "feeds choices through to #add in the order" do
      expect(kernel).to receive(:gets).and_return("2", "1", "1", "quit")
      expect(menu).to receive(:select).with(1).and_return(item_ordered)
      expect(order).to receive(:add).with(item_ordered, 1)
      test_list.new_order
    end

    it "reacts okay to weird user input" do
      expect(kernel).to receive(:gets).and_return("fo", "efew", "rip", "3fwef", "quit")
      test_list.new_order
    end

    it "prints the current order at the end of every loop" do
      expect(kernel).to receive(:gets).and_return("2", "1", "1", "quit")
      expect(menu).to receive(:select).with(1).and_return(item_ordered)
      expect(order).to receive(:add).with(item_ordered, 1)
      expect(order).to receive(:to_s)
      test_list.new_order
    end

    it "allows user to finalise order" do
      expect(kernel).to receive(:gets).and_return("2", "1", "1", "confirm")
      expect(menu).to receive(:select).with(1).and_return(item_ordered)
      expect(order).to receive(:add).with(item_ordered, 1)

      expect{ test_list.new_order }.to output(/Order received!/).to_stdout
    end

    it "throws an error trying to finalise an empty order" do
      skip
    end

    it "pushes order notification to the customers mobile with finalisation" do
      skip
    end
  end
end