WebLookupView = require './web-lookup-view'
{CompositeDisposable} = require 'atom'

module.exports = WebLookup =
  webLookupView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @webLookupView = new WebLookupView(state.webLookupViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @webLookupView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'web-lookup:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @webLookupView.destroy()

  serialize: ->
    webLookupViewState: @webLookupView.serialize()

  toggle: ->
    console.log 'WebLookup was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
