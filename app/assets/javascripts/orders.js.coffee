class window.Order
  constructor: (
    @newOrderDiv = $('.new-order-wrapper'),
    @newDishDiv = $('.add-dish-wrapper'),
    @newOrderForm = $('#new-order-form')[0],
    @newOrderButton = $('.btn-add-order'),
    @createOrderButton = $('.btn-create-order'),
    @closeNewOrderButton = $('.btn-close-new-order'),
    @closeNewDishButton = $('.btn-close-new-dish')
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
    @closeNewDishButton.on 'click', (event) =>
      @newDishDiv.slideUp('slow')

$ ->
  new Order
