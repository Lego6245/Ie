PAGE_MODE_CONSTANTS = require("../constants.cjsx").PAGE_MODE_CONSTANTS
UIActions = require("../actions.cjsx").UIActions
OptionsMenu = require("./Options.cjsx")
PageStateStore = require("../stores/PageStateStore.cjsx")
WidgetGrid = require "./WidgetGrid.cjsx"

Root = React.createClass
    mixins: [Reflux.connect(PageStateStore, "pageState")]

    displayName: "Root"

    _enterOptionsMode: ->
        UIActions.enterState(PAGE_MODE_CONSTANTS.OPTS)

    render: ->
        pageMode = this.state.pageState

        <div id="root">
            { if pageMode == PAGE_MODE_CONSTANTS.LIVE
                <div id="live">
                    <WidgetGrid />
                    <button onClick = { this._enterOptionsMode }>
                        Go To Options
                    </button>
                </div>
            else if pageMode == PAGE_MODE_CONSTANTS.OPTS
                <OptionsMenu />
            else
                <span>I Hate everything</span>
            }
        </div>

module.exports = Root
