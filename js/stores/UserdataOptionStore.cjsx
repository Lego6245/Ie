OptionMixin = require("./OptionMixin.cjsx")

isNumeric = (val) -> not isNaN(parseFloat(n)) and isFinite(n)
isString = (val) -> typeof val is 'string'

UserDataOptionStore = Reflux.createStore
    storeName: "StyleOptionStore"

    mixins: [OptionMixin]

    options: {
        name:       "Unknown"
        locale:     "en-US"
        timezone:   "EST"
    }

    verifiers: {
        username: isString
        locale:   isString # TODO use an enum type for this
        timezone: isString
    }

module.exports = UserDataOptionStore
