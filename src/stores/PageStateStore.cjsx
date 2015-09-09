Reflux = require("reflux")

PAGE_MODES = (require "constants.cjsx").PAGE_MODES
UIActions = (require "actions.cjsx").UIActions

PageStateStore = Reflux.createStore
    listenables: [UIActions]
    # Default state
    pageMode: PAGE_MODES.LIVE

    getInitialState: ->
        return this.pageMode

    onEnterMode: (mode) ->
        this.pageMode = mode
        this.trigger(this.pageMode)

module.exports = PageStateStore
