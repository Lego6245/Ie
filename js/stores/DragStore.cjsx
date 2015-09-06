WidgetActions = (require "../actions.cjsx").WidgetActions


DragStore = Reflux.createStore
    listenables: [WidgetActions]
    # Default state
    draggedWidget: null

    getInitialState: ->
        return this.draggedWidget

    onStartDrag: (widget) ->
        console.log("Started dragging", widget)
        this.draggedWidget = widget
        this.trigger(this.draggedWidget)

    onStopDrag: (widget) ->
        console.log("Stopped dragging")
        this.draggedWidget = null
        this.trigger(this.draggedWidget)

module.exports = DragStore
