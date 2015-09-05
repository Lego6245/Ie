ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

CONSTANTS = require("../constants.cjsx")
PAGE_MODES = CONSTANTS.PAGE_MODES
BKG_MODES = CONSTANTS.BKG_MODES

GlobalOptionsStore = require("../stores/GlobalOptionsStore.cjsx")
PageStateStore = require("../stores/PageStateStore.cjsx")

Actions = require("../actions.cjsx")
UIActions = Actions.UIActions
OptionActions = Actions.OptionActions

Options = React.createClass
    displayName: "Options"

    mixins: [Reflux.connect(GlobalOptionsStore, "globalSettings")]

    _handleEditOption: (name, event) ->
        if GlobalOptionsStore.validateOption(name, event.target.value)
            console.log "passed validation (#{name}, #{event.target.value})"
            OptionActions.editOption(
                name,
                event.target.value)
        else
            console.log "failed validation (#{name}, #{event.target.value})"

    _handleBackgroundToggle: (event) ->
        mode = BKG_MODES.BKG_COLOR
        if event.target.checked == true
            mode = BKG_MODES.BKG_IMG
        OptionActions.editOption("backgroundMode", mode)

    _getBackgroundMode: ->
        if (this.state.globalSettings.backgroundMode == BKG_MODES.BKG_IMG)
            return true
        else
            return false

    _editGlobalOption: (name) ->
        self = this
        (event) -> self._handleEditOption(name, event)

    render: ->
        options = this.state.globalSettings

        <div id="options">
            <span>This is an options panel I guess?</span>
            <input type="text"
                id="widget-background"
                placeholder="#FFFFFF"
                onChange={ this._editGlobalOption("widgetBackground") } />
            <label htmlFor="widget-background">
                Widget Background Color
            </label>
            <input type="text"
                id="widget-foreground"
                placeholder="#FFFFFF"
                onChange={ this._editGlobalOption("widgetForeground") } />
            <label htmlFor="widget-foreground">
                Widget Foreground Color
            </label>
            <input type="text"
                id="widget-border"
                placeholder="#FFFFFF"
                onChange={ this._editGlobalOption("widgetBorder") } />
            <label htmlFor="widgetBorder">Widget Border Color</label>
            <input type="checkbox"
                id="background-mode"
                checked={ this._getBackgroundMode() }
                onChange={ this._handleBackgroundToggle } />
            <label htmlFor="background-mode">Use Background Image</label>
            <input type="text"
                id="background"
                placeholder="#FFFFFF"
                onChange={ this._editGlobalOption("backgroundColor") }  />
            <label htmlFor="background color">Background</label>
            <input type="text"
                id="foreground"
                placeholder="#000000"
                onChange={ this._editGlobalOption("foreground") } />
            <label htmlFor="foreground">Foreground</label>
            <button onClick = { this._exitOptionsMode }>
                Go To Root
            </button>

            <div id="options-debug">
                <span>Options Debug</span><br />
                <span>Widget Background: { options.widgetBackground }</span>
                <span>Widget Foreground: { options.widgetForeground }</span>
                <span>Widget Border: { options.widgetBorder }</span>
                <span>Background Color: { options.foreground }</span>
                <span>Foreground: { options.background }</span>
            </div>
        </div>

    _exitOptionsMode: ->
        UIActions.enterMode(PAGE_MODES.LIVE)

    # getInitialState: 
    #   GlobalSettingsStore.getInitialState.bind(GlobalSettingsStore)
                    

module.exports = Options
