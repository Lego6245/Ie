ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

Root = React.createClass
    displayName: "Root"

    render: ->
        <div id="root">
            This is the root of the dumb app
        </div>

module.exports = Root
