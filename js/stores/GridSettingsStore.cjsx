GridSettingsStore = Reflux.createStore
    # actions this store listens to
    # listenables: [SettingsActions]

    # the name of the store in localstorage
    storeName = "gridSettings"

    # default state
    gridSettings:
        currentSettingsIndex: 0
        grids: [
            {  settingName: "large"

                # space between each tile
                widgetMargin: 20

                # minimum space between the edge of the
                # window and the internal bits
                externalMargin:
                    left:   150
                    right:  150
                    top:    150
                    bottom: 150

                # the basic grid unit of each tile
                gridUnit:
                    x: 150
                    y: 150

                gridDim:
                    x: 4
                    y: 3
            },

            {  settingName: "small"

                # space between each tile
                widgetMargin: 20

                # minimum space between the edge of the
                # window and the internal bits
                externalMargin:
                    left:   150
                    right:  150
                    top:    150
                    bottom: 150

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
        windowWidth = window,innerWidth
        windowHeight = window.innerHeight

        for index, grid in this.gridSettings.grids
            [minWidth, minHeight] = calculateGridSize grid
            if minWidth < windowWidth && minHeight < windowHeight
                return index == oldGridIndex

        return this.gridSettings.grids.length - 1 == oldGridIndex

    # get the current grid object
    getCurrentGrid: ->
        this.gridSettings[this.gridSettings.currentSettingsIndex]

    # update the gridSettings object in local storage and trigger
    # on the current grid
    updateCacheAndTrigger: ->
        window.localStorage.setItem
            this.storeName,
            JSON.stringify(this.gridSettings)

        this.trigger(this.getCurrentGrid())

module.exports = GridSettingsStore
