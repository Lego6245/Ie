ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
PAGE_MODE_CONSTANTS = require("../constants.cjsx").PAGE_MODE_CONSTANTS
UIActions = require("../actions.cjsx").UIActions

Options = React.createClass
    displayName: "Options"

    render: ->
        <div id="options">
            This is an options panel I guess?
            <button onClick = { this._exitOptionsMode }>
                Go To Root
            </button>
        </div>

    _exitOptionsMode: ->
        UIActions.enterState(PAGE_MODE_CONSTANTS.LIVE)

module.exports = Options
