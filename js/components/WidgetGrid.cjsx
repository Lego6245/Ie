GridSettingsStore = require "../stores/GridSettingsStore.cjsx"
translate = (require "../csshelpers.cjsx").translate

WidgetGrid = React.createClass
    displayName: "WidgetGrid"

    mixins: [Reflux.connect(GridSettingsStore, "grid")]

    componentDidMount: ->
        window.addEventListener('resize', this._resizeWindow)

    componentWillUnmount: ->
        window.removeEventListener('resize', this._resizeWindow)

    _resizeWindow: -> 
        wrapper = React.findDOMNode(this.refs.wrapper)
        wrapper.style.marginTop = 
            "#{Math.max(0, (window.innerHeight - wrapper.offsetHeight) / 2)}px"
        GridSettingsStore.recalculateCurrentGridAndTrigger()

    render: ->
        grid = this.state.grid
        # grid uynit and padding
        fullGridUnit = {
            x: grid.gridUnit.x + grid.widgetMargin
            y: grid.gridUnit.y + grid.widgetMargin
        }

        mkGridObj = (x, y) ->
            style = {
                width: grid.gridUnit.x
                height: grid.gridUnit.y
                transform: translate(fullGridUnit.x * x, fullGridUnit.y * y)
                margin: grid.widgetMargin / 2
            }

            <div className="widget-grid-entry"
                 style={style}
                 key={x + "_" + y}>
            </div>

        w = grid.gridDim.x
        h = grid.gridDim.y
        xyPairs = ([c % w, Math.floor(c / w)] for c in [0..w * h - 1])
        gridObjs = (mkGridObj(x, y) for [x, y] in xyPairs)

        innerStyle = {
            width:  fullGridUnit.x * grid.gridDim.x - grid.widgetMargin
            height: fullGridUnit.y * grid.gridDim.y - grid.widgetMargin
            marginLeft:   grid.externalMargin.left
            marginRight:  grid.externalMargin.right
            marginTop:    grid.externalMargin.top
            marginBottom: grid.externalMargin.bottom
        }

        wrapperStyle = {
            width:  fullGridUnit.x * grid.gridDim.x -
                    grid.widgetMargin +
                    grid.externalMargin.left + 
                    grid.externalMargin.right
            height: fullGridUnit.y * grid.gridDim.y -
                    grid.widgetMargin +
                    grid.externalMargin.top + 
                    grid.externalMargin.bottom
        }

        <div id="widget-grid"
             style={wrapperStyle}
             ref="wrapper">
            <div id="widget-grid-inner"
                 style={innerStyle}>
                 {gridObjs}
            </div>
        </div>

module.exports = WidgetGrid
