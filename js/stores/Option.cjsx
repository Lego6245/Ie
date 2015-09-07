OptionActions = require("../actions.cjsx").OptionActions
_ = require "lodash"
invariant = require "invariant"

OptionMixin = 
    listenables: [OptionActions]
    
    getInitialState: ->
        storageState = window.localStorage.getItem(this.storeName)
        if storageState
            this.options = JSON.parse(storageState)
        return this.options

    validateOption: (fieldName, fieldValue) ->
        return fieldName in Object.keys(this.options) and 
            this.validators[fieldName](fieldValue)

    onEditOption: (fieldName, fieldValue) ->
        this.options[fieldName] = fieldValue
        this.cacheAndTrigger()

    cacheAndTrigger: ->
        console.log "caching and triggering"
        window.localStorage.setItem(
            this.storeName,
            JSON.stringify(this.options))
        console.log(this.options)
        this.trigger(this.options)


createStore = (obj) ->
    invariant "options" in Object.keys(obj), 
              "Options Store mising an 'options' field"

    invariant "validators" in Object.keys(obj),
              "Options Store mising a 'validators' field"

    optionFields    = Object.keys(obj.options)
    validatorFields = Object.keys(obj.validators)

    uniqueOptions = _.without.bind(
        this, optionFields).apply(
        this, validatorFields)

    invariant uniqueOptions.length == 0,
              "options #{uniqueOptions} have no validator"

    obj.mixins = (obj.mixins || []).concat(OptionMixin)

    return Reflux.createStore(obj)


module.exports = 
    mixin: OptionMixin
    createStore: createStore
