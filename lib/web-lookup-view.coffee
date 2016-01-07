{TextEditorView, ScrollView} = require 'atom-space-pen-views'

module.exports =
class WebLookupView extends ScrollView
  @content: ->
    @div =>
      @subview 'addressBar', new TextEditorView(mini: true, placeholderText: 'Please enter a URL')
      @tag 'a', '', class: 'button', =>
        @tag 'img', class: 'icon', src: 'atom://web-lookup/public/images/back.png'
      @tag 'a', '', class: 'button', =>
        @tag 'img', class: 'icon', src: 'atom://web-lookup/public/images/reload.png'
      @tag 'a', '', class: 'button', =>
        @tag 'img', class: 'icon', src: 'atom://web-lookup/public/images/next.png'
      @tag 'webview', id: 'webview', src: ""

  constructor: (pathUrl) ->
    super
    @addressBar.setText(pathUrl)
    @addressBar.addClass('urlholder')
    if @webview is undefined
      @webview = @element.querySelector('webview')
    @webview.src = pathUrl

  getTitle: -> 'web-lookup'

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
