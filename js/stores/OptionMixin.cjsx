OptionActions = require("../actions.cjsx").OptionActions

OptionMixin = 
    listenables: [OptionActions]
    
    getInitialState: ->
        storageState = window.localStorage.getItem(this.storeName)
        if storageState
            this.options = JSON.parse(storageState)
        return this.options

    validateOption: (fieldName, fieldValue) ->
        return fieldName in Object.keys(this.options) and 
            this.verifiers[fieldName](fieldValue)

    onEditOption: (fieldName, fieldValue) ->
        this.options[fieldName] = fieldValue
        this.cacheAndTrigger()

    cacheAndTrigger: ->
        console.log "caching and triggering"
        window.localStorage.setItem(
            this.storeName,
            JSON.stringify(this.options))
        this.trigger(this.options)

module.exports = OptionMixin
