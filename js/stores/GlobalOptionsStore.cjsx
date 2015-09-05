PAGE_MODES = require("../constants.cjsx").PAGE_MODES
BKG_MODES = require("../constants.cjsx").BKG_MODES
OptionActions = require("../actions.cjsx").OptionActions

colorRegex = new RegExp("#[0-9a-fA-F]{6}")
isColor = (str) -> colorRegex.test(str)
isNonNull = (val) -> val?

GlobalOptionsStore = Reflux.createStore
    listenables: [OptionActions]

    globalSettings: {
        widgetBackground: "#FFFFFF"
        widgetBorder:     "#FF0000"
        widgetForeground: "#000000"

        foreground:       "#000000"
        backgroundMode:   BKG_MODES.BKG_COLOR
        backgroundImage:  null
        backgroundColor:  "#222222"
    }

    verifiers: {
        widgetBackground:   isColor
        widgetBorder:       isColor
        widgetForeground:   isColor

        foreground:         isColor
        backgroundColor:    isColor
        backgroundMode:     isNonNull
        backgroundImage:    isNonNull
    }

    getInitialState: -> 
        return this.globalSettings

    validateOption: (fieldName, fieldValue) ->
        return this.verifiers[fieldName](fieldValue)
        
    onEditOption: (fieldName, fieldValue) ->
        this.globalSettings[fieldName] = fieldValue
        this.cacheAndTrigger()

    cacheAndTrigger: ->
        # TODO cache
        console.log "caching and triggering"
        this.trigger(this.globalSettings)

module.exports = GlobalOptionsStore
