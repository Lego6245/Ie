OptionMixin = require("./OptionMixin.cjsx")

isNumeric = (val) -> not isNaN(parseFloat(n)) and isFinite(n)
isString = (val) -> typeof val is 'string'

UserInfoOptionStore = Reflux.createStore
    storeName: "UserInfoOptionStore"

    mixins: [OptionMixin]

    options: {
        name:       "Unknown"
        locale:     "en-US"
        timezone:   "EST"
    }

    verifiers: {
        name: isString
        locale:   isString # TODO use an enum type for this
        timezone: isString
    }

module.exports = UserInfoOptionStore
