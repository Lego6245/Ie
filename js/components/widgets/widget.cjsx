CSS = require "../../csshelpers.cjsx"
GridSettingsStore = require "../../stores/GridSettingsStore.cjsx"
WidgetActions = (require "../../actions.cjsx").WidgetActions

createWidgetClass = (obj) ->
    if not obj.acceptsDim?
        throw "no 'acceptsDim' method while trying to instanciate widget
               #{if 'displayName' in obj then " #{obj.displayName}." else "."}"
    React.createClass(obj)

WidgetMixin =
    componentDidMount: () ->
        window.addEventListener('mousemove', this.wContinueDrag)
        window.addEventListener('mouseup', this.wEndDrag)

    componentWillUnmount: () ->
        window.removeEventListener('mousemove', this.wContinueDrag)
        window.removeEventListener('mouseup', this.wEndDrag)

    getInitialState: () ->
        trackingOrigin: undefined
        relativePos:
            x: 0
            y: 0

    wStartDrag: (evt) ->
        console.log evt

        this.setState({
            trackingOrigin:
                x: evt.nativeEvent.x
                y: evt.nativeEvent.y })

        this.setState({
            relativePos:
                x: 0
                y: 0 })

        CSS.addClass(React.findDOMNode(this), "dragging")

    wContinueDrag: (nativeEvent) ->
        if this.state.trackingOrigin?

            this.setState({
                relativePos:
                    x: nativeEvent.x - this.state.trackingOrigin.x
                    y: nativeEvent.y - this.state.trackingOrigin.y })

            React.findDOMNode(this).style.transform = CSS.translate(
                this.props.mountOrigin.x + this.state.relativePos.x,
                this.props.mountOrigin.y + this.state.relativePos.y)

    wEndDrag: (nativeEvt) ->
        if this.state.trackingOrigin?
            # reset the tracking state
            this.setState({trackingOrigin: undefined})

            endSlot = this.props.mountCallback(
                this.props.widgetID,
                this.props.gridSize,
                this.state.relativePos.x + 
                    this.props.mountOrigin.x,
                this.state.relativePos.y +
                    this.props.mountOrigin.y)

            if endSlot?
                console.log "moving widget"
                WidgetActions.moveWidget(
                    this.props.widgetID, 
                    this.props.layoutName,
                    endSlot.x, endSlot.y)

            else
                console.log "widget move failed endslot=#{endSlot}"
                domNode = React.findDOMNode(this)
                # move it to the original position
                domNode.style.transform = CSS.translate(
                    this.props.mountOrigin.x,
                    this.props.mountOrigin.y)

                CSS.removeClass(domNode, "dragging")
        
    widgetStyle: ->
        {
            width: this.props.mountSize.x
            height: this.props.mountSize.y
            transform: CSS.translate(
                this.props.mountOrigin.x,
                this.props.mountOrigin.y)
        }

    ShouldComponentUpdate: (nextState) ->
        return nextState.widget != this.state.widget

    widgetClasses: () ->
        base = {   
            dragging: this.state.trackingOrigin?
            widget: true
        }
        gridSize = this.props.gridSize
        base["sizex-#{gridSize.x}"] = true
        base["sizey-#{gridSize.y}"] = true
        return base

module.exports = {
    createWidgetClass: createWidgetClass
    WidgetMixin: WidgetMixin
}
