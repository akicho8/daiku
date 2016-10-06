# 画像のプレビュー表示
#
# foo.png = サムネ画像
# bar.png = でかい画像
# と仮定して──
#
# foo.png の上にマウスを乗せると bar.png を表示したい
#
#   <a href="bar.png" class="daiku_preview"><img src="foo.png" /></a>
#   $(".daiku_preview").daiku_preview()
#
# bar.png は横800もあるのでできれば横320にして表示したい
#
#   <a href="bar.png" class="daiku_preview"><img src="foo.png" /></a>
#   $(".daiku_preview").daiku_preview(width: 320)
#
# クリックしたときのリンク先は画像ではなく別のページしたい
#
#   <a href="bar.html" class="daiku_preview" rel="bar.png"><img src="foo.png" /></a>
#   $(".daiku_preview").daiku_preview()
#
# マウスを乗せる部分は別に画像でなくてもよい
#
#   <a href="bar.png" class="daiku_preview">foo.png</a>
#   $(".daiku_preview").daiku_preview()
#
# あらかじめaで囲むのが面倒だし、リンクで飛ばしたくないし、クラス名をつけるのも面倒
#
#   <img src="foo.png" rel="bar.png" />
#   $("img[rel]").daiku_preview()
#
# bar.png の上にマウスを乗せると bar.png を原寸表示したい
#
#   <img src="bar.png" width="16" />
#   $("img").daiku_preview()
#
$.daiku_preview = (target, options = {}) ->
  default_options =
    fade_in_delay: 1000.0 / 60 * 15 # フェイドインしてくるときのスピード
    mousemove: true                 # マウスと連動して動かすか？
    offset_x: 20                    # マウスからの距離(X)
    offset_y: 0                     # マウスからの距離(Y)
    float_dom_id: "daiku_preview_float_box" # 浮ぶDOMのid
    tooltip_disable: true           # title属性の内容がホバーして画像の上に乗ってしまうのを防ぐ？

  options = $.extend(true, {}, default_options, options)

  float_box = null
  save_title = null
  img = null

  target.hover (e) ->
    # マウスが乗ったとき
    src = $(@).attr("rel") || $(@).attr("href") || $(@).attr("src")
    # review_width = $(@).attr("review_width")

    if options.tooltip_disable
      save_title = $(@).attr("title")
      $(@).removeAttr("title")

    img = $("<img src=\"#{src}\" alt=\"\" />")

    # でかすぎるプレビューを出さないように縦横の片方を設定できるようにする
    if options.width
      img.attr("width", options.width)
    if options.height
      img.attr("height", options.height)

    # if review_width
    #   img.css
    #     "max-width": review_width

    # bodyの最後に埋め込む
    if false
      # 他のコンテンツを埋め込む場合はdivで囲まないといけない
      $("body").append($("<div id=\"#{options.float_dom_id}\"></div>").html(img))
    else
      img.attr("id", options.float_dom_id)
      $("body").append(img)

    # 浮ぶdivにアクセスしやすくしておく
    float_box = $("##{options.float_dom_id}")

    # マウスのよこに表示
    float_box.css
      left: e.pageX + options.offset_x
      top:  e.pageY + options.offset_y - img.height() / 2
    .fadeIn(options.fade_in_delay)
  , ->
    # マウスが離れたら消去
    float_box.remove()
    # titleを復元
    if save_title
      target.attr("title", save_title)

  if options.mousemove
    target.mousemove (e) ->
      float_box.css
        left: e.pageX + options.offset_x
        top:  e.pageY + options.offset_y - img.height() / 2

$.fn.daiku_preview = (options) ->
  $.daiku_preview($(@), options)

$ ->
  $(".daiku_preview").daiku_preview()
