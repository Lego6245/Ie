Widget = require "./widget.cjsx"
PAGE_MODE_CONSTANTS = (require "../../constants.cjsx").PAGE_MODE_CONSTANTS
PageStateStore = require "../../stores/PageStateStore.cjsx"

TimeWidget = Widget.createWidgetClass

    mixins: [
        Widget.WidgetMixin,
        Reflux.connect(PageStateStore, "pageState")
    ]

    getInitialState: () ->
        setInterval(
            (()->this.setState {date: new Date()}).bind(this),
            1 * 1000)

        return { date: new Date() }

    acceptsDim: (x, y) ->
        return x < 2 && y < 2

    render: -> 
        locale = window.navigator.userLanguage || window.navigator.language
        editing = this.state.pageState == PAGE_MODE_CONSTANTS.EDIT

        classes = Object.assign(this.widgetClasses(),{
            "core-timer-widget": true
        })

        <div className={classNames(classes)}
             onMouseDown={ if editing then this.wStartDrag else undefined}
             onMouseUp={ if editing then this.wEndDrag else undefined}
             style={this.widgetStyle()}
             >
            <time>{this.state.date.toLocaleTimeString(locale)}</time>
            <date>{this.state.date.toLocaleDateString(locale)}</date>
        </div>

module.exports = TimeWidget
