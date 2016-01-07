WebLookupView = require './web-lookup-view'
{CompositeDisposable} = require 'atom'

module.exports = WebLookup =
  webLookupView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'web-lookup:open': => @openWebView()

    atom.workspace.addOpener (uriToOpen) ->
      url = require 'url'
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

  openWebView: (pathUrl) ->
    uri = 'web-lookup://' + pathUrl + atom.workspace.getActiveTextEditor().getPath()
    previousActivePane = atom.workspace.getActivePane()
    atom.workspace.open(uri, split: 'right', searchAllPanes: true).done (view) ->
      previousActivePane.activate()
