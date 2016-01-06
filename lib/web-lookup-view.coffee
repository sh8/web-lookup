{ScrollView} = require 'atom-space-pen-views'

module.exports =
class WebLookupView extends ScrollView
  @content: ->
    @div =>
      @h1 'SpeceCraft'
      @ol =>
        @li click: "displayText", 'test'
        @li class: "message", outlet: "message"

  displayText: ->
    @message.text('super long content that will scroll')

  constructor: (pathUrl) ->
    super

  getTitle: -> 'web-lookup'

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
