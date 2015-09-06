UIActions = require("../actions.cjsx").UIActions
PageStateStore = require("../stores/PageStateStore.cjsx")
GlobalOptionsStore = require("../stores/GlobalOptionsStore.cjsx")

PAGE_MODES = require("../constants.cjsx").PAGE_MODES
BKG = require("../constants.cjsx").BKG_MODES

NavButton = React.createClass
    displayName: "NavButton"

    mixins: [
        Reflux.connect(PageStateStore, "pageState")
    ]

    _handleClick: ->
        if this.state.pageState == this.props.target
            UIActions.enterMode(PAGE_MODES.LIVE) 
        else
            UIActions.enterMode(this.state.pageState)

    render: ->
        classes =
            "nav-button": true
            "active": this.props.target == this.state.pageState

        <div className={classNames classes}
             onClick={this._handleClick}>
            {this.props.children}
        </div>


TopBar = React.createClass
    displayName: "TopBar"

    mixins: [
        Reflux.connect(GlobalOptionsStore, "globalOptions")]
    render: ->
        pageMode = this.state.pageState

        classes = {}

        <nav id="top-bar"
             className={classNames classes}>
            <NavButton target={PAGE_MODES.EDIT}>
                <img src="./img/edit.svg">
            </NavButton>
            <NavButton target={PAGE_MODES.OPTS}>
                <img src="./img/options.svg">
            </NavButton>
        </nav>

module.exports = TopBar
