class window.Order
  constructor: (
    @newOrderDiv = $('.new-order-wrapper'),
    @newOrderForm = $('#new-order-form')[0],
    @newOrderButton = $('.btn-add-order'),
    @createOrderButton = $('.btn-create-order')
  ) ->
    @newOrderButton.on 'click', (event) =>
      @newOrderButton.addClass('hide')
      @newOrderDiv.slideDown('slow')

    @createOrderButton.on 'click', (event) =>
      if @newOrderForm.checkValidity()
        @newOrderDiv.slideUp('slow')
        @newOrderButton.removeClass('hide')
$ ->
  new Order
