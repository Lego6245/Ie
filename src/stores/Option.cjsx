React = require("react")
Reflux = require("reflux")

invariant = require "invariant"
_         = require "lodash"

OptionActions = require("actions.cjsx").OptionActions

name = require("namehelpers.cjsx")

OptionMixin =
    listenables: [OptionActions]

    getInitialState: ->
        storageState = window.localStorage.getItem(this.storeName)
        if storageState
            this.options = JSON.parse(storageState)
        return this.options

    validateOption: (fieldName, fieldValue) ->
        return fieldName in Object.keys(this.options) and
            this.optionTypes[fieldName].validator(fieldValue)

    onEditOption: (fieldName, fieldValue) ->
        this.options[fieldName] = 
            this.optionTypes[fieldName].processor(fieldName, fieldValue)
        console.log "setting", fieldName, "to", this.options[fieldName]
        this.cacheAndTrigger()

    cacheAndTrigger: ->
        console.log "caching and triggering"
        window.localStorage.setItem(
            this.storeName,
            JSON.stringify(this.options))
        console.log(this.options)
        this.trigger(this.options)


createStore = (obj) ->
    # creaate an Option store, checking a few conditionals required
    invariant "options" in Object.keys(obj),
              "Options Store mising an 'options' field"

    invariant "optionTypes" in Object.keys(obj),
              "Options Store mising a 'optionTypes' field"

    optionFields    = Object.keys(obj.options)
    typeFields      = Object.keys(obj.optionTypes)

    uniqueOptions = _.without.bind(
        this, typeFields).apply(
        this, typeFields)

    invariant uniqueOptions.length == 0,
              "options #{uniqueOptions} have no type declaration"

    obj.mixins = (obj.mixins || []).concat(OptionMixin)

    return Reflux.createStore(obj)





### input validation & input element generation ###

colorRegex = new RegExp("#[0-9a-fA-F]{3,6}")
mkGenericInput = (inputType) ->
    (store, fieldName, fieldValue, editOptionCallback) ->
        edit = (event) -> 
            editOptionCallback(store, fieldName, event.target.value)

        <label
            htmlFor={fieldName}
            key={fieldName}>
            {name.legibleVariableName(fieldName)}
            <input type={inputType}
                id={fieldName}
                defaultValue={fieldValue}
                onChange={edit}
                spellCheck={false} />
        </label>

idProcessor = (name, x) -> x

optionTypes =
    string:
        validator: (str) -> typeof(str) == 'string'
        mkInputField: mkGenericInput('text')
        processor: idProcessor

    color:
        validator: (str) -> colorRegex.test(str)
        mkInputField: mkGenericInput('text')
        processor: idProcessor

    img:
        validator: (val) -> val? # TODO
        mkInputField: (store, fieldName, fieldValue, editOptionCallback) ->

            loadAndSignalImage = () ->
                fileList = document.getElementById(fieldName).files
                file = fileList[0]

                reader = new FileReader()
                reader.onload = (e) ->
                    editOptionCallback(store, fieldName, reader.result)

                reader.readAsDataURL(file)

            <label
                htmlFor={fieldName}
                key={fieldName}>
                {name.legibleVariableName(fieldName)}
                <input type='file'
                    id={fieldName}
                    defaultValue={fieldValue}
                    onChange={loadAndSignalImage}
                    spellCheck={false} />
            </label>

        processor: (name, base64) -> "url(#{base64})"

    int:
        validator: (val) -> not isNaN(parseFloat(n)) and isFinite(n)
        mkInputField: mkGenericInput('test')
        processor: parseInt

    enumerated: (someEnum) ->
        enumKeys = Object.keys(someEnum)
        mkOption = (optName) ->
            <option 
                value={optName}
                key={optName}>
                {name.legibleEnumName(optName)}
            </option>


        return {
            validator: (val) ->
                true

            mkInputField: (store, fieldName, fieldValue, editOptionCallback) ->
                edit = (event) -> 
                    editOptionCallback(store, fieldName, event.target.value)

                <label  id={fieldName}
                        key={fieldName}>
                    {name.legibleVariableName(fieldName)}
                    <select id={fieldName}
                            key={fieldName}
                            name={fieldName}
                            onChange={edit}>
                        {mkOption e for e in enumKeys}
                    </select>
                </label>

            processor: idProcessor
        }



module.exports =
    mixin: OptionMixin
    createStore: createStore
    types: optionTypes
