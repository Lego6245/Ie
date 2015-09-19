require("./Options.scss")

Reflux = require("reflux")
React  = require("react/addons")
warna  = require("warna")

CONSTANTS  = require("constants.cjsx")
PAGE_MODES = CONSTANTS.PAGE_MODES
BKG_MODES  = CONSTANTS.BKG_MODES

UserInfoOptionStore = require("stores/UserInfoOptionStore.cjsx")
StyleOptionStore    = require("stores/StyleOptionStore.cjsx")
GridOptionStore     = require("stores/GridOptionStore.cjsx")

PageStateStore = require("stores/PageStateStore.cjsx")

Actions       = require("actions.cjsx")
UIActions     = Actions.UIActions
OptionActions = Actions.OptionActions

name = require("namehelpers.cjsx")
CSS  = require("csshelpers.cjsx")

Options = React.createClass
    displayName: "Options"

    mixins: [
        Reflux.connect(StyleOptionStore, "styleOptions"),
        Reflux.connect(GridOptionStore, "gridOptions"),
        Reflux.connect(UserInfoOptionStore, "userInfoOptions")]

    _handleEditOption: (store, name, value) ->
        console.log store
        if store.validateOption(name, value)
            console.log "passed validation (#{name}, #{value})"
            CSS.removeClass(document.getElementById(name), 'invalid');
            CSS.addClass(document.getElementById(name), 'valid');
            store.onEditOption(name, value)
        else
            console.log "failed validation (#{name}, #{value})"
            CSS.removeClass(document.getElementById(name), 'valid');
            CSS.addClass(document.getElementById(name), 'invalid');

    _handleBackgroundToggle: (event) ->
        mode = BKG_MODES.BKG_COLOR
        if event.target.checked == true
            mode = BKG_MODES.BKG_IMG
        OptionActions.editOption("backgroundMode", mode)

    _isImageMode: ->
        if (this.state.styleOptions.backgroundMode == BKG_MODES.BKG_IMG)
            return true
        else
            return false

    _exitOptionsMode: ->
        document.getElementById("options").className = ""
        UIActions.enterMode(PAGE_MODES.LIVE)

    render: () ->
        self = this

        makeOptions = (store, obj) ->
            mkInput = (store, fieldName, fieldValue) ->
                store.optionTypes[key].mkInputField(
                    store,
                    fieldName,
                    fieldValue,
                    self._handleEditOption)

            return (mkInput(store, key, obj[key]) for key in Object.keys(obj))

        userStyleInputs = makeOptions(
            StyleOptionStore,
            this.state.styleOptions)

        userInfoInputs = makeOptions(
            UserInfoOptionStore,
            this.state.userInfoOptions)


        # gridStyleInputs = this._makeOptions(
        #     GridOptionStore,
        #     this.state.gridOptions)

        <div id="options"
            style={{
                backgroundColor: warna.darken(
                    this.state.styleOptions.widgetForeground,
                    0.5).hex
            }}
            >
            <h1>Style</h1>
            {userStyleInputs}

            <h1>User Info</h1>
            {userInfoInputs}

            <h1>Install Widgets</h1>
            todo: put anything here

            <button onClick = { this._exitOptionsMode }>
                Close Menu
            </button>


        </div>

    # getInitialState:
    #   GlobalOptionsStore.getInitialState.bind(GlobalOptionsStore)


module.exports = Options


           # <label htmlFor="widget-background">Widget Background Color</label>
            # <input type="text"
            #     id="widget-background"
            #     defaultValue={ this.state.styleOptions.widgetBackground }
            #     onChange={ this._editGlobalOption("widgetBackground") } />
            # <label htmlFor="widget-foreground">Widget Foreground Color</label>
            # <input type="text"
            #     id="widget-foreground"
            #     defaultValue={ this.state.styleOptions.widgetForeground }
            #     onChange={ this._editGlobalOption("widgetForeground") } />
            # <label htmlFor="widgetBorder">Widget Border Color</label>
            # <input type="text"
            #     id="widget-border"
            #     defaultValue={ this.state.styleOptions.widgetBorder }
            #     onChange={ this._editGlobalOption("widgetBorder") } />
            # <input type="checkbox"
            #     id="background-mode"
            #     checked={ this._isImageMode() }
            #     onChange={ this._handleBackgroundToggle } />
            # <label htmlFor="background-mode">Use Background Image</label>
            # <label htmlFor="background-image">Background Image File</label>
            # <input type="file"
            #     id="background-image"
            #     disabled={ not this._isImageMode() }
            #     onChange={ this._handleBackgroundImage } />
            # <label htmlFor="background">Background</label>
            # <input type="text"
            #     id="background"
            #     defaulValue={ this.state.styleOptions.backgroundColor }
            #     onChange={ this._editGlobalOption("backgroundColor") }  />
            # <label htmlFor="foreground">Foreground</label>
            # <input type="text"
            #     id="foreground"
            #     defaulValue={ this.state.styleOptions.foreground }
            #     onChange={ this._editGlobalOption("foreground") } />
