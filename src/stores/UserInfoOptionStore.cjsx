Reflux = require("reflux")

Option = require("stores/Option.cjsx")

isNumeric = (val) -> not isNaN(parseFloat(n)) and isFinite(n)
isString = (val) -> typeof val is 'string'

UserInfoOptionStore = Option.createStore
    storeName: "UserInfoOptionStore"

    options: {
        name:       "Unknown"
        locale:     "en-US"
        timezone:   "EST"
    }

    validators: {
        name: isString
        locale:   isString # TODO use an enum type for this
        timezone: isString
    }

module.exports = UserInfoOptionStore
