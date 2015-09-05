PAGE_MODE_CONSTANTS = require("../constants.cjsx").PAGE_MODE_CONSTANTS
UIActions = require("../actions.cjsx").UIActions

PageStateStore = Reflux.createStore
    listenables: [UIActions]
    # Default state
    pageMode: PAGE_MODE_CONSTANTS.LIVE

    getInitialState: ->
        return this.pageMode

    onEnterState: (mode) ->
        this.pageMode = mode
        this.trigger(this.pageMode)

module.exports = PageStateStore
