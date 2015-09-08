Enum = require("enum")

PAGE_MODES = new Enum([
    "LIVE",
    "EDIT",
    "OPTS"    
])

BKG_MODES = new Enum([
    "BKG_COLOR",
    "BKG_IMG"
])

module.exports = {
    PAGE_MODES: PAGE_MODES
    BKG_MODES:  BKG_MODES
}
