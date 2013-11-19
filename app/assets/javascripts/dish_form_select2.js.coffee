class window.DishFormSelect2
  constructor: ->
    @input = $('.dish-description-field')
    @descriptions = $('#data')?.data('dishes-descriptions')?.dishes_descriptions || []

  bindSelect2: ->
    @input.select2(
      data: @descriptionsToSelect2Structure()
      containerCssClass: 'form-control'
      createSearchChoice: (text) =>
        id: @generateId(), text: text
    )

  descriptionsToSelect2Structure: ->
    [0...@descriptions.length].map (num) => text: @descriptions[num], id: num

  generateId: ->
    new Date().getTime()

$ ->
  new DishFormSelect2().bindSelect2()
