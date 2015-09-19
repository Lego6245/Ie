require ("./Weather.scss")

Reflux     = require("reflux")
React      = require("react")
classNames = require("classnames")
_          = require("lodash")

PageStateStore = require("stores/PageStateStore.cjsx")
Widget = require("widgets/Widget.cjsx")

WeatherWidget = Widget.createWidgetClass

    mixins: [
        Widget.WidgetMixin,
        Reflux.connect(PageStateStore, "pageState")
    ]

    getDefaultProps: () ->
        {
            weather: [
                {
                    day: "today"
                    condition: "sunny"
                    high: 91
                    low: 76
                },
                {
                    day: "mon"
                    condition: "sunny"
                    high: 91
                    low: 76
                },
                {
                    day: "mon"
                    condition: "sunny"
                    high: 91
                    low: 76
                },
                {
                    day: "mon"
                    condition: "sunny"
                    high: 91
                    low: 76
                },
                {
                    day: "mon"
                    condition: "sunny"
                    high: 91
                    low: 76
                },
                {
                    day: "mon"
                    condition: "sunny"
                    high: 91
                    low: 76
                },

            ]
        }

    acceptsDim: (x, y) ->
        return x == 2 && y == 2

    renderBasePanel: ->
        classes = {
            "core-mail-widget": true
        }

        invertedColors = {
            backgroundColor: this.state.userStyle.widgetForeground
            color: this.state.userStyle.widgetBackground
        }

        mkWeather = (weather, index) ->
            <div className="weather" key={index}>
                <span className="day">{weather.day}</span>
                <img src={"img/icons/#{weather.condition}.png"} />
                <span className="high">{weather.high}</span>
                <span className="low">{weather.low}</span>
            </div>

        fiveday = (mkWeather d, i for d, i in this.props.weather[1..])

        <div className={classNames(classes)}
             >
             <div className="window-bar"
                 style={invertedColors}>
                <img src="img/icons/rain-drop.png" className="icon window" />
                <a href="#">
                    <span className="icon options">
                        <img src="img/icons/options-icon.png" />
                    </span>
                </a>
                <h3>the weather for today</h3>
            </div>

            <div className="today">
            </div>

            <div className="five-day">
                {fiveday}
            </div>
        </div>

module.exports = WeatherWidget
