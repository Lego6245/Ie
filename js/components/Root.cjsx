PAGE_MODES = require("../constants.cjsx").PAGE_MODES
BKG = require("../constants.cjsx").BKG_MODES

UserStyleStore = require("../stores/UserStyleStore.cjsx")
PageStateStore = require("../stores/PageStateStore.cjsx")

UIActions = require("../actions.cjsx").UIActions

WidgetGrid = require "./WidgetGrid.cjsx"
TopBar = require "./TopBar.cjsx"
OptionsMenu = require("./Options.cjsx")


enter = (state) ->
    return () -> UIActions.enterMode(state)

Root = React.createClass
    displayName: "Root"

    mixins: [
        Reflux.connect(PageStateStore, "pageState"),
        Reflux.connect(UserStyleStore, "globalOptions")]

    _makeBackgroundStyle: () ->
        gO = this.state.globalOptions
        return switch gO.backgroundMode
            when BKG.BKG_COLOR then {backgroundColor: gO.backgroundColor}
            when BKG.BKG_IMG   then {
                backgroundImage: gO.backgroundImage,
                backgroundColor: gO.backgroundColor}
            else throw "unhandled case looking for background mode"

    render: ->
        pageMode = this.state.pageState

        classes = {
            "mode-live": pageMode == PAGE_MODES.LIVE
            "mode-edit": pageMode == PAGE_MODES.EDIT
            "mode-opts": pageMode == PAGE_MODES.OPTS }

        <div id="root"
             className={classNames(classes)}
             style={this._makeBackgroundStyle()}
             >
            <TopBar />
            <WidgetGrid />
            <OptionsMenu />
            { if pageMode == PAGE_MODES.LIVE
                <div id="live">
                    <button onClick = { enter(PAGE_MODES.OPTS) }>
                        Go To Options
                    </button>
                    <button onClick = { enter(PAGE_MODES.EDIT) }>
                        Edit
                    </button>
                </div>
            else if pageMode == PAGE_MODES.EDIT
                <button onClick={enter(PAGE_MODES.LIVE)}>
                    Exit Edit Mode
                </button>
            else
                <span>Error: State not recognized!</span>
            }

        </div>

module.exports = Root
