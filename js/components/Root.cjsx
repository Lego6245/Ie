PAGE_MODE = require("../constants.cjsx").PAGE_MODE_CONSTANTS
UIActions = require("../actions.cjsx").UIActions
OptionsMenu = require("./Options.cjsx")
PageStateStore = require("../stores/PageStateStore.cjsx")
WidgetGrid = require "./WidgetGrid.cjsx"

enter = (state) ->
    return () -> UIActions.enterState(state)

Root = React.createClass
    mixins: [Reflux.connect(PageStateStore, "pageState")]

    displayName: "Root"

    _enterOptionsMode: ->
        UIActions.enterState(PAGE_MODE.OPTS)

    render: ->
        pageMode = this.state.pageState

        classes = {
            "mode-live": pageMode == PAGE_MODE.LIVE
            "mode-edit": pageMode == PAGE_MODE.EDIT
            "mode-opts": pageMode == PAGE_MODE.OPTS }

        <div id="root"
             className={classNames(classes)}>
            <WidgetGrid />

            { if pageMode == PAGE_MODE.LIVE
                <div id="live">
                    <button onClick = { enter(PAGE_MODE.OPTS) }>
                        Go To Options
                    </button>
                    <button onClick = { enter(PAGE_MODE.EDIT) }>
                        Edit
                    </button>
                </div>
            else if pageMode == PAGE_MODE.OPTS
                <OptionsMenu />
            else if pageMode == PAGE_MODE.EDIT
                <button onClick={enter(PAGE_MODE.LIVE)}>
                    Exit Edit Mode
                </button>
            else
                <span>Error: State not recognized!</span>
            }

        </div>

module.exports = Root
