GridSettingsStore = require "../stores/GridSettingsStore.cjsx"
WidgetStore = require "../stores/WidgetStore.cjsx"
translate = (require "../csshelpers.cjsx").translate

GridTileIndicator = React.createClass
    render: ->
        grid = this.props.grid

        style = {
            width: grid.gridUnit.x
            height: grid.gridUnit.y
            transform: translate(
                (grid.gridUnit.x + grid.widgetMargin) * this.props.x,
                (grid.gridUnit.y + grid.widgetMargin) * this.props.y)
            margin: grid.widgetMargin / 2
            #borderColor: this.props.color
        }

        <div className="widget-grid-entry"
             style={style}>
        </div>

findOccupiedSpaces = (grid, widgets) ->
    # init OccupiedSpaces
    occupiedSpaces = new Array(grid.gridDim.x)
    for ix in [0 .. (grid.gridDim.x - 1)]
        occupiedSpaces[ix] = new Array(grid.gridDim.y)
        for iy in [0 .. (grid.gridDim.y - 1)]
            occupiedSpaces[ix][iy] = false

    # fill spaces occuupied by widgets
    for widget in widgets
        wl = widget.layouts[grid.settingName]
        if wl?
            for ix in [0..wl.dimension.x - 1]
                for iy in [0..wl.dimension.y - 1]
                    xo = wl.position.x + ix
                    yo = wl.position.y + iy
                    console.log occupiedSpaces, xo, yo
                    occupiedSpaces[xo][yo] = true

    return occupiedSpaces

WidgetGrid = React.createClass
    displayName: "WidgetGrid"

    mixins: [
        Reflux.connect(GridSettingsStore, "grid"),
        Reflux.connect(WidgetStore, "widgets")
    ]

    componentDidMount: ->
        window.addEventListener('resize', this._resizeWindow)
        this._centerWithMargin()

    componentWillUnmount: ->
        window.removeEventListener('resize', this._resizeWindow)

    _centerWithMargin: ->
        wrapper = React.findDOMNode(this.refs.wrapper)
        wrapper.style.marginTop =
            "#{Math.max(0, (window.innerHeight - wrapper.offsetHeight) / 2)}px"

    _resizeWindow: ->
        this._centerWithMargin()
        GridSettingsStore.recalculateCurrentGridAndTrigger()

    # returns null on failure (occupied spot, etc)
    fitWidgetToGrid: (widgetID, widgetGridSize, pixelX, pixelY) ->
        grid = this.state.grid
        gridX = Math.round(pixelX/(grid.widgetMargin/2 + grid.gridUnit.x))
        gridY = Math.round(pixelY/(grid.widgetMargin/2 + grid.gridUnit.y))
    
        occupiedSpaces =
            findOccupiedSpaces(
                this.state.grid,
                (w for w in this.state.widgets when w.uuid != widgetID))

        isOpen = (x,y) -> 
            0 <= x and x < grid.gridDim.x and
            0 <= y and y < grid.gridDim.y and
            not occupiedSpaces[x][y]

        console.log widgetGridSize, gridX, gridY

        for ix in [0 .. widgetGridSize.x - 1]
            for iy in [0 .. widgetGridSize.y - 1]
                if not isOpen(gridX + ix, gridY + iy)
                    console.log "#{gridX + ix}, #{gridY + iy} is not open"
                    return null

        return {
            x: gridX
            y: gridY
        }

    render: ->
        grid = this.state.grid

        occupiedSpaces =
            findOccupiedSpaces(
                this.state.grid,
                this.state.widgets)

        # grid uynit and padding
        fullGridUnit = {
            x: grid.gridUnit.x + grid.widgetMargin
            y: grid.gridUnit.y + grid.widgetMargin
        }

        w = grid.gridDim.x
        h = grid.gridDim.y
        xyPairs = ([c % w, Math.floor(c / w)] for c in [0..w * h - 1])

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

        indicators = (<GridTileIndicator 
            grid={grid} x={x} y={y} key={ind}
            color={if occupiedSpaces[x][y] then "red" else "blue"} 
            /> for [x, y], ind in xyPairs)

        widgetLayouts = 
            ([w, w.layouts[grid.settingName]] for w in this.state.widgets)

        <div id="widget-grid"
             style={wrapperStyle}
             ref="wrapper">
            <div id="widget-grid-inner"
                 style={innerStyle}>
                 {indicators}

                 {(<w.WidgetClass 
                    mountOrigin={{
                        x: wl.position.x * fullGridUnit.x + grid.widgetMargin/2
                        y: wl.position.y * fullGridUnit.y + grid.widgetMargin/2
                    }}
                    mountSize={{
                        x: wl.dimension.x * fullGridUnit.x - grid.widgetMargin
                        y: wl.dimension.y * fullGridUnit.y - grid.widgetMargin 
                    }}
                    gridSize={wl.dimension}
                    layoutName={grid.settingName}
                    key={w.uuid}
                    widgetID={w.uuid}
                    mountCallback={this.fitWidgetToGrid}
                    /> for [w, wl] in widgetLayouts when wl?)}
            </div>
        </div>

module.exports = WidgetGrid
