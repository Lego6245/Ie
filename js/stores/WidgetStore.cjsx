WidgetStore = Reflux.createStore
    displayName: "WidgetStore"

    # actions this store listens to
    # listenables: [UpdateSettings]

    # default state
    widgets: []

    # the initial state of the store from localstorage
    # if that fails, use the default
    getInitialState: ->
        storageState = window.localStorage.getItem("widgets")
        if storageState
            this.widgets = JSON.parse(storageState)
        return widgets

    onAddWidget: (widget) ->
        this.widgets.push(widget)
        this.trigger(this.widgets)

module.exports = WidgetStore
