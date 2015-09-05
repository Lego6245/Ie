ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
PAGE_MODES = require("../constants.cjsx").PAGE_MODES
GlobalSettingsStore = require("../stores/GlobalSettingsStore.cjsx")
PageStateStore = require("../stores/PageStateStore.cjsx")
Actions = require("../actions.cjsx")
UIActions = Actions.UIActions
OptionActions = Actions.OptionActions


Options = React.createClass
    displayName: "Options"

    mixins: [Reflux.connect(GlobalSettingsStore, "globalSettings")]

    _handleEditOption: (name, event) ->
        if GlobalSettingsStore.validateOption(name, event.target.value)
            console.log "passed validation (#{name}, #{event.target.value})"
            OptionActions.editOption(
                name,
                event.target.value)
        else
            console.log "failed validation (#{name}, #{event.target.value})"

    _editGlobalOption: (name) ->
        self = this
        (event) -> self._handleEditOption(name, event)

    render: ->
        options = this.state.globalSettings

        <div id="options">
            <span>This is an options panel I guess?</span>
            <div id="colorscheme">
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
            </div>
            <input type="text"
                id="background"
                placeholder="#FFFFFF"
                onChange={ this._editGlobalOption("backgroundColor") }  />
            <label htmlFor="background">Background</label>
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
                <span>Background: { options.foreground }</span>
                <span>Foreground: { options.background }</span>
            </div>
        </div>

    _exitOptionsMode: ->
        UIActions.enterMode(PAGE_MODES.LIVE)

    # getInitialState: 
    #   GlobalSettingsStore.getInitialState.bind(GlobalSettingsStore)
                    

module.exports = Options
