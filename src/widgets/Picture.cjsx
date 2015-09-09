Reflux     = require("reflux")
React      = require("react")
classNames = require("classnames")
_          = require("lodash")

PAGE_MODES = require("constants.cjsx").PAGE_MODES
PageStateStore = require("stores/PageStateStore.cjsx")
Widget = require("widgets/Widget.cjsx")

imgfallback = "img/mocks/happy-tile-20.png"

PictureWidget = Widget.createWidgetClass

    mixins: [
        Widget.WidgetMixin,
        Reflux.connect(PageStateStore, "pageState")
    ]

    acceptsDim: (x, y) ->
        # Picture widget can be any size
        return true

    render: ->
        editing = this.state.pageState == PAGE_MODES.EDIT
        classes = _.assign(this.widgetClasses(),{
            "core-mail-widget": true
        })

        invertedColors = {
            backgroundColor: this.state.userStyle.widgetForeground
            color: this.state.userStyle.widgetBackground
        }

        widget_data_imgurl = this.props.widgetData.img
        imgurl = if widget_data_imgurl? then widget_data_imgurl else imgfallback

        <div className={classNames(classes)}
             onMouseDown={ if editing then this.wStartDrag else undefined}
             onMouseUp={ if editing then this.wEndDrag else undefined}
             style={this.widgetStyle()}>
            <img src={ imgurl } />
        </div>

module.exports = PictureWidget
