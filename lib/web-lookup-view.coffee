{$, TextEditorView, ScrollView} = require 'atom-space-pen-views'

module.exports =
class WebLookupView extends ScrollView
  @content: ->
    @div =>
      @tag 'a', '', click: 'backPage', class: 'button', outlet: 'back', =>
        @tag 'img', class: 'icon', src: 'atom://web-lookup/public/images/back.png'
      @tag 'a', '', click: 'reloadPage', class: 'button', outlet: 'reload', =>
        @tag 'img', class: 'icon', src: 'atom://web-lookup/public/images/reload.png'
      @tag 'a', '', click: 'nextPage', class: 'button', outlet: 'next', =>
        @tag 'img', class: 'icon', src: 'atom://web-lookup/public/images/next.png'
      @subview 'addressBar', new TextEditorView(mini: true, placeholderText: 'Please enter a URL or a search term here')
      @tag 'webview', id: 'webview', src: ""

  initialize: (pathUrl) ->
    super
    @addToolTips()
    @addressBar.addClass('urlholder')
    if @webview is undefined
      @webview = @element.querySelector('webview')
    @webview.src = pathUrl

    @tabBar = $('.pane.active').find('.tab-bar')

    @webview.addEventListener "did-finish-load", =>
      @setTitle()

  addToolTips: ->
    try
      atom.tooltips.add @back, {title: 'Go Back'}
      atom.tooltips.add @reload, {title: 'Reload'}
      atom.tooltips.add @next, {title: 'Go Next'}
    catch ex
      console.dir ex

  backPage: ->
    @webview.goBack()

  reloadPage: ->
    @webview.reload()

  nextPage: ->
    @webview.goForward()

  setTitle: ->
    pathUrl = @webview.src
    if pathUrl
      url = require 'url'
      {host, pathname, query} = url.parse(pathUrl, true)
      if host.match(/google/)
        q = query["q"]
        if q isnt undefined
          @addressBar.setText(q)
        else
          @addressBar.setText('')
      else
        @addressBar.setText(pathUrl)

    tabBarTitle = @tabBar.children('.active').find('.title')
    title = @webview.getTitle()
    tabBarTitle.text(title)

  getTitle: ->
    tabBarTitle = @tabBar.children('.active').find('.title')
    title = tabBarTitle.text()
    return title

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
