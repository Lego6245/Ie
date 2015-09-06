Widget = require "./widget.cjsx"
PAGE_MODES = (require "../../constants.cjsx").PAGE_MODES
PageStateStore = require "../../stores/PageStateStore.cjsx"

PictureWidget = Widget.createWidgetClass

    mixins: [
        Widget.WidgetMixin,
        Reflux.connect(PageStateStore, "pageState")
    ]

    getDefaultProps: () ->
        {
            img: "file:///home/jtao/Downloads/happy-tile-20.png"
            
        }

    acceptsDim: (x, y) ->
        # Picture widget can be any size
        return true

    render: ->
        editing = this.state.pageState == PAGE_MODES.EDIT
        classes = Object.assign(this.widgetClasses(),{
            "core-mail-widget": true
        })

        invertedColors = {
            backgroundColor: this.state.userStyle.widgetForeground
            color: this.state.userStyle.widgetBackground
        }

        <div className={classNames(classes)}
             onMouseDown={ if editing then this.wStartDrag else undefined}
             onMouseUp={ if editing then this.wEndDrag else undefined}
             style={this.widgetStyle()}>
            <img src={ this.props.img } />
        </div>

module.exports = PictureWidget
