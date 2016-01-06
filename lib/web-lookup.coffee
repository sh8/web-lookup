WebLookupView = require './web-lookup-view'
{CompositeDisposable} = require 'atom'
url = require 'url'

module.exports = WebLookup =
  webLookupView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'web-lookup:toggle': => @openWebView()
    atom.workspace.addOpener (uriToOpen) ->
      try
        {protocol, host, pathname} = url.parse(uriToOpen)
      catch error
        return
      return unless protocol is 'web-lookup:'

      try
        pathname = decodeURI(pathname) if pathname
      catch error
        return
      pathUrl = 'http://google.co.jp'
      @webLookupView = new WebLookupView(pathUrl)

  deactivate: ->
    @subscriptions.dispose()
    @webLookupView.destroy()

  serialize: ->
    webLookupViewState: @webLookupView.serialize()

  openWebView: ->
    console.log 'WebLookup was toggled!'

    uri = 'web-lookup://'+atom.workspace.getActiveTextEditor().getPath()
    previousActivePane = atom.workspace.getActivePane()
    atom.workspace.open(uri, split: 'right', searchAllPanes: true).done (view) ->
      previousActivePane.activate()
