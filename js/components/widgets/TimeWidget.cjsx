Widget = require "./widget.cjsx"
PAGE_MODES = (require "../../constants.cjsx").PAGE_MODES
PageStateStore = require "../../stores/PageStateStore.cjsx"

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

    render: ->
        locale = window.navigator.userLanguage || window.navigator.language
        editing = this.state.pageState == PAGE_MODES.EDIT

        classes = Object.assign(this.widgetClasses(),{
            "core-timer-widget": true
        })

        d = this.state.date
        utcoff = d.getTimezoneOffset() / 60
        utcstr = if utcoff < 0 then "UTC+#{utcoff}:00"  else "UTC-#{utcoff}:00"
        time = "#{d.getHours()}:#{d.getMinutes()}"
        datestr = this.state.date.toLocaleDateString()

        weekdays = new Array(7)
        weekdays[0] = "sunday"
        weekdays[1] = "monday"
        weekdays[2] = "yuesday"
        weekdays[3] = "wednesday"
        weekdays[4] = "thursday"
        weekdays[5] = "friday"
        weekdays[6] = "saturday"

        weekday = weekdays[d.getDay()]

        months = new Array(12)
        months[0]  = "january"
        months[1]  = "feburary"
        months[2]  = "march"
        months[3]  = "april"
        months[4]  = "may"
        months[5]  = "june"
        months[6]  = "july"
        months[7]  = "august"
        months[8]  = "september"
        months[9]  = "october"
        months[10] = "november"
        months[11] = "december"
        month = months[d.getUTCMonth() + 1]

        dom = d.getUTCDate()
        year = d.getUTCFullYear()


        invertedColors = {
            backgroundColor: this.state.userStyle.widgetForeground
            color: this.state.userStyle.widgetBackground
        }

        backgroundBorder = {
            borderColor: this.state.userStyle.widgetBackground
        }

        <div className={classNames(classes)}
             onMouseDown={ if editing then this.wStartDrag else undefined}
             onMouseUp={ if editing then this.wEndDrag else undefined}
             style={this.widgetStyle()}>

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
                    <object type="image/svg+xml" 
                            data="img/icons/clock-moon.png"
                            className="icon status">
                    </object>
                </div>
                <div className="clock-info">
                    <span className="utc">({utcstr})</span>
                    <span className="time">{time}</span>
                    <span className="date">
                        {"#{weekday}, #{month} #{dom}, #{year}" }
                    </span>
                </div>
            </div>
        </div>

module.exports = TimeWidget
