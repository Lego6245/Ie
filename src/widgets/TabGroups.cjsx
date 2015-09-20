Reflux     = require("reflux")
React      = require("react")
_          = require("lodash")

PageStateStore = require("stores/PageStateStore.cjsx")
Widget = require("widgets/Widget.cjsx")

TabGroupsWidget = Widget.createWidgetClass


    mixins: [
        Widget.WidgetMixin,
        Reflux.connect(PageStateStore, "pageState")
    ]

    getDefaultProps: () ->
        {
            tabGroups: [
                {
                    groupName: "Fun"
                    groupMembers: [
                        {
                            linkName: "Reddit"
                            linkUri: "https://reddit.com"
                        },
                        {
                            linkName: "LoLesports"
                            linkUri: "https://na.lolesports.com"
                        }
                    ]
                },
                {
                    groupName: "Work"
                    groupMembers: [
                        {
                            linkName: "Github"
                            linkUri: "https://github.com"
                        },
                        {
                            linkName: "Trello"
                            linkUri: "https://trello.com"
                        }
                    ]
                }
            ]
        }

    acceptsDim: (x, y) ->
        # Widget can be any size
        return true

    renderBasePanel: ->
        invertedColors = {
            backgroundColor: this.state.userStyle.widgetForeground
            color: this.state.userStyle.widgetBackground
        }
        mkLinkGroup = (link, index) ->
            <span className="link-name">{link.linkName}</span>

        mkTabGroup = (group, index) ->
            <a key={index} href="#">
            {(mkLinkGroup l, i for l, i in group.groupMembers)}
            </a>

        tabGroups = (mkTabGroup t, i for t, i in this.props.tabGroups)

        <div className="core-mail-widget">
             <div className="window-bar"
                  style={invertedColors}>
                <img src="img/icons/email.png" className="icon window" />
                <a href="#">
                    <span className="icon options">
                        <img src="img/icons/options-icon.png" />
                    </span>
                </a>
                <h3>goodjobpj@gmail.com</h3>
                <a href="#">
                    <h4>10 unread</h4>
                </a>
            </div>

            <div className="tabGroup">
                {tabGroups}
            </div>
            <a href="#">
                <div className="read-more">
                    <span className="read-more-icon">
                        <img src="img/icons/down-chevron.png" />
                    </span>
                </div>
            </a>
        </div>

module.exports = TabGroupsWidget
