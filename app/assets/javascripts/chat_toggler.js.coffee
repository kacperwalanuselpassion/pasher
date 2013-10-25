class window.Chat.Toggler
  constructor: ->
    @chatEl = $('.chat-wrapper')
    @el = @chatEl.find('.chat-toggler')
    @bindings()

  bindings: ->
    @el.click =>
      if @chatEl.hasClass('minimalized')
        @chatEl.removeClass('minimalized')
      else
        @chatEl.addClass('minimalized')

$ ->
  new Chat.Toggler()