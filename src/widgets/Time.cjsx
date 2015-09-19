require ("./Time.scss")

Reflux     = require("reflux")
React      = require("react")
_          = require("lodash")
classNames = require("classnames")
moment     = require("moment")

PageStateStore = require("stores/PageStateStore.cjsx")
Widget = require("widgets/Widget.cjsx")

TimeWidget = Widget.createWidgetClass

    mixins: [
        Widget.WidgetMixin,
        Reflux.connect(PageStateStore, "pageState")
    ]

    getInitialState: () ->
        return { date: new Date() }

    componentDidMount: () ->
        this.interval = setInterval(
            (()->this.setState {date: new Date()}).bind(this),
            1 * 1000)

    componentWillUnmount: () ->
        clearInterval(this.interval)

    acceptsDim: (x, y) ->
        return x < 2 && y < 2

    renderBasePanel: ->
        locale = window.navigator.userLanguage || window.navigator.language

        classes = {
            "core-timer-widget": true
        }

        d = this.state.date
        m = moment()

        invertedColors = {
            backgroundColor: this.state.userStyle.widgetForeground
            color: this.state.userStyle.widgetBackground
        }

        backgroundBorder = {
            borderColor: this.state.userStyle.widgetBackground
        }

        <div className={classNames(classes)}>

            <div className="window-bar" style={invertedColors}>
                <img src="img/icons/clock.png" />
                
                <a href="#">
                    <span className="icon options">
                        <img src="img/icons/options-icon.png" />
                    </span>
                </a>

                <h3>eastern standard time</h3>
            </div>
            <div className="clock-content"
                style={backgroundBorder}>
                <div className="status" style={invertedColors}>
                    <img src="img/icons/clock-moon.png"
                         className="icon status" />
                </div>
                <div className="clock-info">
                    <span className="utc">(UTC{m.format("Z")})</span>
                    <span className="time">{m.format("hh:mm")}
                        <span className="ampm">{m.format("A")}</span></span>
                    <span className="date">
                        {m.format("dddd, MMMM Do, YYYY").toLowerCase()}
                    </span>
                </div>
            </div>
        </div>

module.exports = TimeWidget
