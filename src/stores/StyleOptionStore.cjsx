Reflux = require("reflux")

CONSTANTS  = require("constants.cjsx")
PAGE_MODES = CONSTANTS.PAGE_MODES
BKG_MODES  = CONSTANTS.BKG_MODES

OptionActions = require("actions.cjsx").OptionActions
Option        = require("stores/Option.cjsx")
opt           = require("stores/OptionTypes.cjsx")

colorRegex = new RegExp("#[0-9a-fA-F]{3,6}")


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

    optionTypes: {
        widgetBackground:   opt.color
        widgetBorder:       opt.color
        widgetForeground:   opt.color

        foreground:         opt.color
        backgroundColor:    opt.color
        backgroundMode:     opt.enumerated(BKG_MODES)
        backgroundImage:    opt.img
        topBarHeight:       opt.int
    }

module.exports = StyleOptionStore
