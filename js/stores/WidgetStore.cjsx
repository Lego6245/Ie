WidgetActions = (require "../actions.cjsx").WidgetActions

WidgetStore = Reflux.createStore
    # actions this store listens to
    listenables: [WidgetActions]

    widgetKinds : {
        timer: require "../components/widgets/TimeWidget.cjsx"
        mail: require "../components/widgets/Mail.cjsx"
        weather: require "../components/widgets/Weather.cjsx"
        picture: require "../components/widgets/Picture.cjsx"
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
        },
        {
            widgetKind: "picture"
            data: 
                img: "img/mocks/happy-tile-20.png"
            layouts:
                large:
                    position: {x: 4, y: 0}
                    dimension: {x: 2, y: 1}
            uuid: "fake-uuid-4"
        },
        {
            widgetKind: "picture"
            data: 
                img: "img/mocks/tile-21.png"
            layouts:
                large:
                    position: {x: 4, y: 1}
                    dimension: {x: 2, y: 1}
            uuid: "fake-uuid-5"
        },
        {
            widgetKind: "picture"
            data: 
                img: "img/mocks/tile-22.png"
            layouts:
                large:
                    position: {x: 4, y: 2}
                    dimension: {x: 2, y: 1}
            uuid: "fake-uuid-6"
        }
    ]

    getWidgetClass: (widgetInstance) ->
        return this.widgetKinds[widgetInstance.widgetKind]

    # the initial state of the store from localstorage
    # if that fails, use the default
    getInitialState: ->
        storageState = window.localStorage.getItem("widgets")
        if storageState
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

    onRemoveWidget: (widgetID) ->
        console.log("trying to remoev widget", widgetID)
        for widget in this.widgets
            if widget.uuid == widgetID
                console.log("removing widget with ID", widget.uuid)
                widgetIndex = this.widgets.indexOf(widget)
                this.widgets.splice(widgetIndex, 1)
                this.cacheAndTrigger()

    cacheAndTrigger: () ->
        this.trigger(this.widgets)
        window.localStorage.setItem(
            "widgets", 
            JSON.stringify(this.widgets))


module.exports = WidgetStore
