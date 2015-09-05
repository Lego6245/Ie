GridSettingsStore = Reflux.createStore
    # actions this store listens to
    # listenables: [SettingsActions]

    # the name of the store in localstorage
    storeName = "gridSettings"

    # default state
    gridSettings: [
        # large
        {
            settingName: "large"

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

        #small
        {
            settingName: "small"

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
        return this.gridSettings

    onChangeGridSettings: (index, newGrid) ->
        this.gridSettings[index] = newGrid
        this.updateCacheAndTrigger()

    updateCacheAndTrigger: () ->
        window.localStorage.setItem
            this.storeName,
            JSON.stringify(this.gridSettings)

        this.trigger(this.gridSettings)

module.exports = GridSettingsStore
