WidgetActions = (require "../actions.cjsx").WidgetActions

WidgetStore = Reflux.createStore
    # actions this store listens to
    listenables: [WidgetActions]

    # default state
    widgets: [
        {
            WidgetClass: require "../components/widgets/TimeWidget.cjsx"
            layouts:
                small:
                    position: {x: 0, y: 0}
                    dimension: {x: 2, y: 1}
                large:
                    position: {x: 0, y: 0}
                    dimension: {x: 2, y: 2}
            uuid: "fake-uuid"
        },
        {
            WidgetClass: require "../components/widgets/TimeWidget.cjsx"
            layouts:
                small:
                    position: {x: 0, y: 2}
                    dimension: {x: 2, y: 1}
                large:
                    position: {x: 2, y: 0}
                    dimension: {x: 1, y: 1}
            uuid: "fake-uuid2"
        }


        {
            WidgetClass: require "../components/widgets/TimeWidget.cjsx"
            layouts:
                large:
                    position: {x: 3, y: 2}
                    dimension: {x: 1, y: 1}
            uuid: "fake-uuid3"
        }
    ]

    # the initial state of the store from localstorage
    # if that fails, use the default
    getInitialState: ->
        storageState = window.localStorage.getItem("widgets")
        if storageState
            this.widgets = JSON.parse(storageState)
        return this.widgets

    onAddWidget: (widget) ->
        this.widgets.push(widget)
        this.trigger(this.widgets)

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
        this.trigger(this.widgets)

module.exports = WidgetStore
