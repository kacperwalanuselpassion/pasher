class window.Order
  constructor: (
    @newOrderDiv = $('.new-order-wrapper'),
    @editOrderDiv = $('.edit-order-wrapper'),
    @editDishDiv = $('.edit-dish-wrapper'),
    @newDishDiv = $('.add-dish-wrapper'),
    @addBitcoinAddressDiv = $('.add-bitcoin-address-wrapper'),
    @newOrderForm = $('#new-order-form')[0],
    @newOrderButton = $('.btn-add-order'),
    @createOrderButton = $('.btn-create-order'),
    @closeNewOrderButton = $('.btn-close-new-order'),
    @closeEditOrderButton = $('.btn-close-edit-order'),
    @closeNewDishButton = $('.btn-close-new-dish'),
    @closeEditDishButton = $('.btn-close-edit-dish'),
    @closeAddBitcoinAddressButton = $('.btn-close-add-bitcoin-address'),
    @addBitcoinAddressButton = $('.btn-add-bitcoin-address')
  ) ->
    @newOrderButton.on 'click', (event) =>
      @newOrderButton.addClass('hide')
      @newOrderDiv.slideDown('slow')

    @createOrderButton.on 'click', (event) =>
      if @newOrderForm.checkValidity()
        @newOrderDiv.slideUp('slow')
        @newOrderButton.removeClass('hide')

    @closeNewOrderButton.on 'click', (event) =>
      @newOrderDiv.slideUp('slow')
      @newOrderButton.removeClass('hide')

    @closeEditOrderButton.on 'click', (event) =>
      @editOrderDiv.slideUp('slow')
      @editOrderButton.removeClass('hide')

    @closeNewDishButton.on 'click', (event) =>
      @newDishDiv.slideUp('slow')

    @closeEditDishButton.on 'click', (event) =>
      @editDishDiv.slideUp('slow')

    @closeAddBitcoinAddressButton.on 'click', (event) =>
      @addBitcoinAddressDiv.slideUp('slow')

    @addBitcoinAddressButton.on 'click', (event) =>
      @addBitcoinAddressDiv.slideUp('slow')

$ ->
  new Order
