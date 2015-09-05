GridSettingsStore = require "../stores/GridSettingsStore.cjsx"

WidgetGrid = React.createClass
    displayName: "WidgetGrid"

    mixins: [Reflux.connect(GridSettingsStore, "grid")]

    render: ->

        grid = this.state.grid
        mkGridObj = (x, y) ->
            style = {
                "width": grid.gridUnit.x
                "height": grid.gridunit.y
            }

            <div className="widget-grid-outline"
                style={style}>
            </div>

        <div id="widget-grid">
            {gridObjects}    
        </div>

module.exports = WidgetGrid
