GlobalSettingsStore = Reflux.createStore
    # actions this store listens to
    # listenables: [UpdateSettings]

    # the name of the store in localstorage
    storeName = "globalSettings"

    # default state
    globalSettings: {
        colorScheme:
            widgetBackground: "#FFFFFF"
            widgetBorder:     "#FF0000"
            widgetForeground: "#000000"

        foreground: #000000
        background: #FFFFFF
    }

    # the initial state of the store from localstorage
    # if that fails, use the default
    getInitialState: ->
        storageState = window.localStorage.getItem(this.storeName)
        if storageState
            this.globalSettings = JSON.parse(storageState)
        return globalSettings

    writeState: ->
        window.localStorage.setItem(
            this.storeName,
            JSON.stringify(this.globalSettings))
        
module.exports = GlobalSettingsStore
