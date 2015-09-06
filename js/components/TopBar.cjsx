CONSTANTS = require "../constants.cjsx"
PAGE_MODES = CONSTANTS.PAGE_MODES
BKG = CONSTANTS.BKG_MODES

PageStateStore = require "../stores/PageStateStore.cjsx"
UserStyleStore = require "../stores/UserStyleStore.cjsx"
WidgetStore = require "../stores/WidgetStore.cjsx"
DragStore = require "../stores/DragStore.cjsx"

Actions = require "../actions.cjsx"
UIActions = Actions.UIActions
WidgetActions = Actions.WidgetActions

NavButton = React.createClass
    displayName: "NavButton"

    mixins: [
        Reflux.connect(PageStateStore, "pageState")
    ]

    _handleClick: ->
        if this.state.pageState == this.props.target
            UIActions.enterMode(PAGE_MODES.LIVE)
        else
            UIActions.enterMode(this.props.target)

    render: ->
        classes =
            "nav-button": true
            "active": this.props.target == this.state.pageState

        <a className={classNames classes}
             onClick={this._handleClick}>
            {this.props.children}
        </a>

WidgetTrash = React.createClass
    displayName: "WidgetTrash"

    mixins: [
        Reflux.connect(WidgetStore, "widgets"),
        Reflux.connect(DragStore, "drag"),
        Reflux.connect(PageStateStore, "pageState")
    ]

    aboutToTrash: false

    trashClass: ->
        if this.aboutToTrash
            return "trashing"
        else
            return ""

    _enabled: ->
        return this.state.pageState == PAGE_MODES.EDIT

    _handleMouseOver: ->
        if this._enabled() and this.state.drag?
            this.aboutToTrash = true

    _handleMouseOut: ->
        if this._enabled() and this.state.drag?
            this.aboutToTrash = false

    _handleMouseUp: ->
        console.log("Enabled: ", this._enabled())
        console.log("Dragging: ", this.state.drag)
        if this._enabled() and this.state.drag?
            WidgetActions.removeWidget(this.state.drag.props.widgetID)
            this.aboutToTrash = false

    render: ->
        <img id="widget-trash"
            src="./img/icons/trash.png"
            className={ this.trashClass() }
            onMouseOver={ this._handleMouseOver }
            onMouseOut={ this._handleMouseOut }
            onMouseUp={ this._handleMouseUp } />

        
TopBar = React.createClass
    displayName: "TopBar"

    mixins: [
        Reflux.connect(UserStyleStore, "userStyle")]
    render: ->
        pageMode = this.state.pageState

        classes = {}

        <nav id="top-bar"
             className={classNames classes}
             style={{height: this.state.userStyle.topbarHeight}}>
            <NavButton target={PAGE_MODES.EDIT}>
                <img src="./img/icons/edit-mode.png" />
            </NavButton>
            <NavButton target={PAGE_MODES.OPTS}>
                <img src="./img/icons/options-mode.png" />
            </NavButton>
            <WidgetTrash />
            <h1 id="motd">Welcome, Gabriel</h1>
        </nav>

module.exports = TopBar
