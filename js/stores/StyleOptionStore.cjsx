CONSTANTS  = require("../constants.cjsx")
PAGE_MODES = CONSTANTS.PAGE_MODES
BKG_MODES  = CONSTANTS.BKG_MODES

OptionActions = require("../actions.cjsx").OptionActions
Options       = require("./Option.cjsx")

colorRegex = new RegExp("#[0-9a-fA-F]{3,6}")
isColor = (str) -> colorRegex.test(str)
isNonNull = (val) -> val?
isNumeric = (val) -> not isNaN(parseFloat(n)) and isFinite(n)

StyleOptionStore = Option.createStore
    storeName: "StyleOptionStore"

    options: {
        widgetBackground: "#FFFBF5"
        widgetBorder:     "#FFFBF5"
        widgetForeground: "#604A5B"

        foreground:       "#000000"
        backgroundMode:   BKG_MODES.BKG_COLOR
        backgroundImage:  null
        backgroundColor:  "#222222"
        topBarHeight: 50
    }

    validators: {
        widgetBackground:   isColor
        widgetBorder:       isColor
        widgetForeground:   isColor

        foreground:         isColor
        backgroundColor:    isColor
        backgroundMode:     isNonNull
        backgroundImage:    isNonNull
        topBarHeight:       isNumeric
    }

module.exports = StyleOptionStore
