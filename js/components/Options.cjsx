ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

CONSTANTS = require "../constants.cjsx"
PAGE_MODES = CONSTANTS.PAGE_MODES
BKG_MODES = CONSTANTS.BKG_MODES

UserStyleStore = require "../stores/UserStyleStore.cjsx"
PageStateStore = require "../stores/PageStateStore.cjsx"

Actions = require "../actions.cjsx"
UIActions = Actions.UIActions
OptionActions = Actions.OptionActions

Options = React.createClass
    displayName: "Options"

    mixins: [Reflux.connect(UserStyleStore, "globalOptions")]

    _handleEditOption: (name, event) ->
        if UserStyleStore.validateOption(name, event.target.value)
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

    _isImageMode: ->
        if (this.state.globalOptions.backgroundMode == BKG_MODES.BKG_IMG)
            return true
        else
            return false

    _handleBackgroundImage: ->
        fileList = document.getElementById("background-image").files
        file = fileList[0]
        reader = new FileReader()
        reader.onload = (e) ->
            console.log(reader.result)
            OptionActions.editOption(
                "backgroundImage",
                "url(#{reader.result})")
        reader.readAsDataURL(file)

    _editGlobalOption: (name) ->
        self = this
        (event) -> self._handleEditOption(name, event)

    render: ->
        options = this.state.globalOptions

        <div id="options">
            <h1>Options</h1>
            <label htmlFor="widget-background">Widget Background Color</label>
            <input type="text"
                id="widget-background"
                defaultValue={ this.state.globalOptions.widgetBackground }
                onChange={ this._editGlobalOption("widgetBackground") } />
            <label htmlFor="widget-foreground">Widget Foreground Color</label>
            <input type="text"
                id="widget-foreground"
                defaultValue={ this.state.globalOptions.widgetForeground }
                onChange={ this._editGlobalOption("widgetForeground") } />
            <label htmlFor="widgetBorder">Widget Border Color</label>
            <input type="text"
                id="widget-border"
                defaultValue={ this.state.globalOptions.widgetBorder }
                onChange={ this._editGlobalOption("widgetBorder") } />
            <input type="checkbox"
                id="background-mode"
                checked={ this._isImageMode() }
                onChange={ this._handleBackgroundToggle } />
            <label htmlFor="background-mode">Use Background Image</label>
            <label htmlFor="background-image">Background Image File</label>
            <input type="file"
                id="background-image"
                disabled={ not this._isImageMode() }
                onChange={ this._handleBackgroundImage } />
            <label htmlFor="background">Background</label>
            <input type="text"
                id="background"
                value={ this.state.globalOptions.backgroundColor }
                onChange={ this._editGlobalOption("backgroundColor") }  />
            <label htmlFor="foreground">Foreground</label>
            <input type="text"
                id="foreground"
                value={ this.state.globalOptions.foreground }
                onChange={ this._editGlobalOption("foreground") } />
            <button onClick = { this._exitOptionsMode }>
                Go To Root
            </button>
        </div>

    _exitOptionsMode: ->
        document.getElementById("options").className = ""
        UIActions.enterMode(PAGE_MODES.LIVE)

    # getInitialState: 
    #   GlobalSettingsStore.getInitialState.bind(GlobalSettingsStore)
                    

module.exports = Options
