PAGE_MODES = require("../constants.cjsx").PAGE_MODES
BKG_MODES = require("../constants.cjsx").BKG_MODES
OptionActions = require("../actions.cjsx").OptionActions

colorRegex = new RegExp("#[0-9a-fA-F]{6}")
isColor = (str) -> colorRegex.test(str)
isNonNull = (val) -> val?
isNumeric = (val) -> not isNaN(parseFloat(n)) and isFinite(n)

UserStyleStore = Reflux.createStore
    listenables: [OptionActions]

    storeName: "globalOptions"

    globalSettings: {
        widgetBackground: "#FFFBF5"
        widgetBorder:     "#FFFBF5"
        widgetForeground: "#604A5B"

        foreground:       "#000000"
        backgroundMode:   BKG_MODES.BKG_COLOR
        backgroundImage:  null
        backgroundColor:  "#222222"
        topbarHeight: 50
    }

    verifiers: {
        widgetBackground:   isColor
        widgetBorder:       isColor
        widgetForeground:   isColor

        foreground:         isColor
        backgroundColor:    isColor
        backgroundMode:     isNonNull
        backgroundImage:    isNonNull
        topBarHeight:       isNumeric
    }

    getInitialState: -> 
        storageState = window.localStorage.getItem(this.storeName)
        if storageState and false
            this.globalSettings = JSON.parse(storageState)
        return this.globalSettings

    validateOption: (fieldName, fieldValue) ->
        return this.verifiers[fieldName](fieldValue)
        
    onEditOption: (fieldName, fieldValue) ->
        this.globalSettings[fieldName] = fieldValue
        this.cacheAndTrigger()

    cacheAndTrigger: ->
        console.log "caching and triggering"
        window.localStorage.setItem(
            this.storeName,
            JSON.stringify(this.globalSettings))
        this.trigger(this.globalSettings)

module.exports = UserStyleStore
