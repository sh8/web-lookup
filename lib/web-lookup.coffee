WebLookupView = require './web-lookup-view'
{$} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'

module.exports = WebLookup =
  webLookupView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    atom.tabs = []

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'web-lookup:openHalfScreen': => @openWebView('https://google.com')
    @subscriptions.add atom.commands.add 'atom-workspace', 'web-lookup:openFullScreen': => @openWebView('https://google.com', true)
    @subscriptions.add atom.commands.add '.urlholder', 'web-lookup:search': => @search()

    atom.workspace.addOpener (uriToOpen) =>
      url = require 'url'
      try
        {protocol, host, pathname, query} = url.parse(uriToOpen)
      catch error
        return
      return unless protocol is 'web-lookup:'

      try
        pathname = decodeURI(pathname) if pathname
      catch error
        return
      pathUrl = query
      webLookupView = new WebLookupView(pathUrl)
      atom.tabs.push(webLookupView)
      return webLookupView

  deactivate: ->
    @subscriptions.dispose()
    index = atom.tabs.indexOf(atom.workspace.getActivePaneItem())
    atom.tabs[index].destroy()
    atom.tabs[index].delete(index)

  serialize: ->
    webLookupViewState: @webLookupView.serialize()

  openWebView: (pathUrl, fullScreen=false) ->
    uri = 'web-lookup://' + "?" + pathUrl
    if fullScreen
      atom.workspace.open(uri)
    else
      atom.workspace.open(uri, split: 'right')

  search: () ->
    index = atom.tabs.indexOf(atom.workspace.getActivePaneItem())
    pathUrl = atom.tabs[index].addressBar.getText()
    if pathUrl.match(/^http:\/\//) or pathUrl.match(/^https:\/\//)
      atom.tabs[index].webview.src = pathUrl
    else if pathUrl.match(/^.{2,}\..{2,}/)
      atom.tabs[index].webview.src = 'http://' + pathUrl
    else
      atom.tabs[index].webview.src = 'https://google.com/search?q=' + pathUrl
