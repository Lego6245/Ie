Root = require "./components/Root.cjsx"

window.onload = () ->

    # render the root element to render on each store change
    console.log "rendering root component to '#app'"

    React.render(
        <Root/>,
        document.getElementById('app')
    )
