#
# その場で画像ズーム
#
# foo.png の上にマウスを乗せると foo.png を拡大するには？
#
#   <img src="foo.png" class="toggleable" />
#   $(".toggleable").image_toggleable()
#
$.fn.image_toggleable = (options) ->
  default_options =
    original_width: "auto"
    original_height: "auto"
    width: 256
    height: 256
    has_shift_key: true
    speed: "normal"

  options = $.extend(true, {}, default_options, options)

  $(@).toggle (e) ->
    if (options.has_shift_key and e.shiftKey) or !options.has_shift_key
      position = $(@).position()
      $(@)
        .css
          position:"absolute"
          top: position.top
          left: position.left
        .animate
          width: options.width
          height: options.height
          left: position.left - (options.width / 4)
          top: position.top - (options.height / 4)
        , options.speed
  , (e) ->
    $(@)
      .css
        width: options.original_width
        height: options.original_height
        top: "auto"
        left: "auto"
        opacity: 1.0
        position: "static"
      .show()

#
# マウスが乗ったら薄くする
#
$.fn.opacity_over = (from = 1.0, to = 0.65, down_speed = "fast", revert_spped = "fast") ->
  $(@).each ->
    $(@)
    # .css
    #   opacity: from
    #   filter: "alpha(opacity=#{from * 100})"
    .hover ->
      $(@).fadeTo(down_speed, to)
    , ->
      $(@).fadeTo(revert_spped, from)

#
# 指定のaはクリックするとトップのフレームの location.href を書き換えて移動させる
#
# 使い方:
#   link_to("Google", "http://www.google.co.jp/", :class => "over_iframe")
#   $("a.over_iframe").over_iframe()
#
$.fn.iframe_over_link = ->
  $(@).click (e) ->
    top.location.href = $(@).attr("href")
    e.preventDefault()
    e.stopPropagation()
    true
