GridSettingsStore = Reflux.createStore
    # actions this store listens to
    # listenables: [SettingsActions]

    # the name of the store in localstorage
    storeName: "gridSettings"

    # default state
    gridSettings:
        currentSettingsIndex: 0
        grids: [
            {  
                settingName: "large"

                # space between each tile
                widgetMargin: 20

                # minimum space between the edge of the
                # window and the internal bits
                externalMargin:
                    left:   10
                    right:  50
                    top:    50
                    bottom: 10

                # the basic grid unit of each tile
                gridUnit:
                    x: 150
                    y: 150

                gridDim:
                    x: 4
                    y: 3
            },

            {  
                settingName: "small"

                # space between each tile
                widgetMargin: 2

                # minimum space between the edge of the
                # window and the internal bits
                externalMargin:
                    left:   10
                    right:  10
                    top:    10
                    bottom: 10

                # the basic grid unit of each tile
                gridUnit:
                    x: 80
                    y: 80

                gridDim:
                    x: 3
                    y: 4
            },
        ]

    # the initial state of the store from localstorage
    # if that fails, use the default
    getInitialState: ->
        storageState = window.localStorage.getItem(this.storeName)
        if storageState
            this.gridSettings = JSON.parse(storageState)
        this.recalculateCurrentGrid()
        return this.getCurrentGrid()

    ###################
    # event listeners #
    ###################

    onChangeGridSettings: (index, newGrid) ->
        this.gridSettings[index] = newGrid
        this.updateCacheAndTrigger()

    ###########
    # helpers #
    ###########

    # determine which grid to use, based on the current window dimensions
    # returns true if the current grid changed. Gives priority to ones
    # earlier on in the array
    recalculateCurrentGrid: ->
        oldGridIndex = this.gridSettings.currentSettingsIndex
        windowWidth = window.innerWidth
        windowHeight = window.innerHeight

        calculateGridSize = (grid) ->
            w = grid.externalMargin.left + 
                grid.externalMargin.right +
                (grid.gridUnit.x + grid.widgetMargin) * grid.gridDim.x +
                grid.widgetMargin

            h = grid.externalMargin.top + 
                grid.externalMargin.bottom +
                (grid.gridUnit.y + grid.widgetMargin) * grid.gridDim.y +
                grid.widgetMargin

            return [w, h]

        for grid, index in this.gridSettings.grids
            [minWidth, minHeight] = calculateGridSize grid
            if minWidth < windowWidth && minHeight < windowHeight
                this.gridSettings.currentSettingsIndex = index
                return index != oldGridIndex

        this.gridSettings.currentSettingsIndex =
            this.gridSettings.grids.length - 1

        return this.gridSettings.currentSettingsIndex != oldGridIndex

    recalculateCurrentGridAndTrigger: ->
        if this.recalculateCurrentGrid()
            this.updateCacheAndTrigger()

    # get the current grid object
    getCurrentGrid: ->
        this.gridSettings.grids[this.gridSettings.currentSettingsIndex]

    # update the gridSettings object in local storage and trigger
    # on the current grid
    updateCacheAndTrigger: ->
        window.localStorage.setItem(
            this.storeName,
            JSON.stringify(this.gridSettings))

        this.trigger(this.getCurrentGrid())

module.exports = GridSettingsStore
