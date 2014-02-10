class FlashNotice
  constructor: ->
    @bindings()

  bindings: ->
    @getFlashNoticeEl().on('mouseover', -> $(@).remove())

  getFlashNoticeEl: ->
    $('.flash-notice-container')

$ ->
  new FlashNotice()