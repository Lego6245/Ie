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

    _handleEditOption: (event) ->
        OptionActions.editOption(event.target.props.optionName, event.target.value)

    render: ->
        console.log(GlobalSettingsStore)
        options = this.state.globalSettings
        console.log(this.state)

        <div id="options">
            <span>This is an options panel I guess?</span>
            <div id="colorscheme">
                <input type="text"
                    optionName="widgetBackground"
                    id="widget-background"
                    placeholder="#FFFFFF"
                    onChange={ this._handleEditOption } />
                <label htmlFor="widget-background">Widget Background Color</label>
                <input type="text"
                    optionName="widgetForeground"
                    id="widget-foreground"
                    placeholder="#FFFFFF"
                    onChange={ this._handleEditOption } />
                <label htmlFor="widget-foreground">Widget Foreground Color</label>
                <input type="text"
                    optionName="widgetBorder"
                    id="widget-border"
                    placeholder="#FFFFFF"
                    onChange={ this._handleEditOption } />
                <label htmlFor="widgetBorder">Widget Border Color</label>
            </div>
            <input type="text"
                optionName="background"
                id="background"
                placeholder="#FFFFFF"
                onChange={ this._handleEditOption }  />
            <label htmlFor="background">Background</label>
            <input type="text"
                optionName="foreground"
                id="foreground"
                placeholder="#000000"
                onChange={ this._handleEditOption } />
            <label htmlFor="foreground">Foreground</label>
            <button onClick = { this._exitOptionsMode }>
                Go To Root
            </button>

            <div id="options-debug">
                <span>Options Debug</span><br>
                <span>Widget Background: { options.widgetBackground }</span>
                <span>Widget Foreground: { options.widgetForeground }</span>
                <span>Widget Border: { options.widgetBorder }</span>
                <span>Background: { options.foreground }</span>
                <span>Foreground: { options.background }</span>
            </div>
        </div>

    _exitOptionsMode: ->
        UIActions.enterMode(PAGE_MODES.LIVE)

    #getInitialState: GlobalSettingsStore.getInitialState.bind(GlobalSettingsStore)
                    

module.exports = Options
