translate = (x, y) -> "translate(#{x}px,#{y}px)"

hasClass = (ele,cls) ->
    !!ele.className.match(new RegExp('(\\s|^)'+cls+'(\\s|$)'));

addClass = (ele,cls) ->
    if (!hasClass(ele,cls))
        ele.className += " "+cls

removeClass = (ele,cls) ->
    if (hasClass(ele,cls))
        reg = new RegExp('(\\s|^)'+cls+'(\\s|$)')
        ele.className=ele.className.replace(reg,' ')


module.exports = {
    translate: translate
    removeClass: removeClass
    addClass: addClass
    hasClass: hasClass
}

