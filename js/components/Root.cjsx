Reflux     = require("reflux")
React      = require("react")
classNames = require("classnames")

CONSTANTS  = require("../constants.cjsx")
PAGE_MODES = CONSTANTS.PAGE_MODES
BKG        = CONSTANTS.BKG_MODES

StyleOptionStore = require("../stores/StyleOptionStore.cjsx")
PageStateStore   = require("../stores/PageStateStore.cjsx")

UIActions = require("../actions.cjsx").UIActions

WidgetGrid  = require("./WidgetGrid.cjsx")
TopBar      = require("./TopBar.cjsx")
OptionsMenu = require("./Options.cjsx")


enter = (state) ->
    return () -> UIActions.enterMode(state)

Root = React.createClass
    displayName: "Root"

    mixins: [
        Reflux.connect(PageStateStore, "pageState"),
        Reflux.connect(StyleOptionStore, "userStyle")]

    _makeBackgroundStyle: () ->
        style = this.state.userStyle
        return switch style.backgroundMode
            when BKG.BKG_COLOR then {backgroundColor: style.backgroundColor}
            when BKG.BKG_IMG   then {
                backgroundImage: style.backgroundImage,
                backgroundColor: style.backgroundColor}
            else throw new Error("unhandled case looking for background mode")

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
        </div>

module.exports = Root
