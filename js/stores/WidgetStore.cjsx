WidgetActions = (require "../actions.cjsx").WidgetActions

WidgetStore = Reflux.createStore
    # actions this store listens to
    listenables: [WidgetActions]

    widgetKinds : {
         timer: require "../components/widgets/TimeWidget.cjsx"
         mail: require "../components/widgets/Mail.cjsx"
         weather: require "../components/widgets/Weather.cjsx"
    }

    # default state
    widgets: [
        {
            widgetKind: "timer"
            layouts:
                large:
                    position: {x: 0, y: 0}
                    dimension: {x: 2, y: 1}
            uuid: "fake-uuid"
        },
        {
            widgetKind: "mail"
            layouts:
                large:
                    position: {x: 0, y: 1}
                    dimension: {x: 2, y: 2}
            uuid: "fake-uuid-2"
        },
        {
            widgetKind: "weather"
            layouts:
                large:
                    position: {x: 2, y: 0}
                    dimension: {x: 2, y: 2}
            uuid: "fake-uuid-3"
        }
    ]

    getWidgetClass: (widgetInstance) ->
        return this.widgetKinds[widgetInstance.widgetKind]

    # the initial state of the store from localstorage
    # if that fails, use the default
    getInitialState: ->
        storageState = window.localStorage.getItem("widgets")
        if storageState and false
            this.widgets = JSON.parse(storageState)
        return this.widgets

    onAddWidget: (widget) ->
        this.widgets.push(widget)
        this.cacheAndTrigger()

    # moves a widget so its top left corner is at grid position x,y
    # assumes safe to move
    onMoveWidget: (widgetID, layout, x, y) ->
        for widget in this.widgets
            if widget.uuid == widgetID
                widget.layouts[layout].position =
                    x: x
                    y: y
                console.log "moved widget '#{widgetID}'"
                console.log this.widgets
                break
        this.cacheAndTrigger()

    cacheAndTrigger: () ->
        this.trigger(this.widgets)
        window.localStorage.setItem(
            "widgets", 
            JSON.stringify(this.widgets))


module.exports = WidgetStore
