PAGE_MODES = require("../constants.cjsx").PAGE_MODES
UIActions = require("../actions.cjsx").UIActions
OptionsMenu = require("./Options.cjsx")
PageStateStore = require("../stores/PageStateStore.cjsx")
WidgetGrid = require "./WidgetGrid.cjsx"

enter = (state) ->
    return () -> UIActions.enterMode(state)

Root = React.createClass
    displayName: "Root"

    mixins: [Reflux.connect(PageStateStore, "pageState")]

    render: ->
        pageMode = this.state.pageState

        classes = {
            "mode-live": pageMode == PAGE_MODES.LIVE
            "mode-edit": pageMode == PAGE_MODES.EDIT
            "mode-opts": pageMode == PAGE_MODES.OPTS }

        <div id="root"
             className={classNames(classes)}>
            <WidgetGrid />
            { if pageMode == PAGE_MODES.LIVE
                <div id="live">
                    <button onClick = { enter(PAGE_MODES.OPTS) }>
                        Go To Options
                    </button>
                    <button onClick = { enter(PAGE_MODES.EDIT) }>
                        Edit
                    </button>
                </div>
            else if pageMode == PAGE_MODES.OPTS
                <OptionsMenu />
            else if pageMode == PAGE_MODES.EDIT
                <button onClick={enter(PAGE_MODES.LIVE)}>
                    Exit Edit Mode
                </button>
            else
                <span>Error: State not recognized!</span>
            }

        </div>

module.exports = Root
