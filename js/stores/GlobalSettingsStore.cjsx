OptionActions = require("../actions.cjsx").OptionActions

GlobalSettingsStore = Reflux.createStore
    # actions this store listens to
    listenables: [OptionActions]

    # the name of the store in localstorage
    storeName = "globalSettings"

    # default state
    globalSettings: {
        widgetBackground: "#FFFFFF"
        widgetBorder:     "#FF0000"
        widgetForeground: "#000000"

        foreground:       "#000000"
        background:       "#FFFFFF"
    }

    # the initial state of the store from localstorage
    # if that fails, use the default
    getInitialState: ->
        console.log("They want my body")
        storageState = window.localStorage.getItem(this.storeName)
        if storageState
            this.globalSettings = JSON.parse(storageState)
        return this.globalSettings

    writeState: ->
        window.localStorage.setItem(
            this.storeName,
            JSON.stringify(this.globalSettings))

    onEditOption: (target, value) ->
        console.log("Help I'm being touched")
        this.globalSettings[targetOption] = value
        this.trigger(this.globalSettings)
        
module.exports = GlobalSettingsStore
