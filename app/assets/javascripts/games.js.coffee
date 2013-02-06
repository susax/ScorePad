# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#top_lineup_1").attr("name","now")
  $("#bottom_lineup_1").attr("name","next_batter")
  $("[name=now]","#lineup").css( "color", "red" )

# ストライクボタン
  $("#strike_add").click ->
    strike_count = $("#strike").text()
    strike_count = parseInt(strike_count)
    if (strike_count is 2)
      $("#strike").text 0
      $("#ball").text 0
      $("#out_add").click()
    else
      $("#strike").text strike_count += 1

# ファールボタン
  $("#fall").click ->
    strike_count = $("#strike").text()
    strike_count = parseInt(strike_count)
    if (strike_count < 2) 
      $("#strike").text strike_count += 1

# ボールボタン
  $("#ball_add").click ->
    ball_count = $("#ball").text()
    ball_count = parseInt(ball_count)
    if (ball_count is 3)
      $("#ball").text 0
      $("#strike").text 0
    else
      $("#ball").text ball_count += 1

# アウトボタン
  $("#out_add").click ->
    out_count = $("#out").text()
    out_count = parseInt(out_count)
    $("#strike").text 0
    $("#ball").text 0
    now_lineup = $("[name=now]","#lineup").index()
    if (out_count is 2)
      $("#out").text 0
      inning_count = $("#inning").text()
      top_or_bottom = $("#top_or_bottom").text()
      inning_count = parseInt(inning_count)
      $("[name=next_batter]","#lineup").css( "color", "red" )
      if (now_lineup is 8)
        $("[name=now]","#lineup").parent().children().eq(0).attr("name","next_batter")
        $("[name=now]","#lineup").removeAttr("name style")
        $("[style='color: red;']","#lineup").attr("name","now")
      else
        $("[name=now]","#lineup").next().attr("name","next_batter")
        $("[name=now]","#lineup").removeAttr("name style")
        $("[style='color: red;']","#lineup").attr("name","now")
      if (top_or_bottom is "回表")
        $("#top_or_bottom").text "回裏"
      else
        $("#inning").text inning_count += 1
        $("#top_or_bottom").text "回表"
    else
      $("#out").text out_count += 1
      if (now_lineup is 8)
        $("[name=now]","#lineup").parent().children().eq(0).css( "color", "red" )
        $("[name=now]","#lineup").removeAttr("name style")
        $("[style='color: red;']","#lineup").attr("name","now")
      else
        $("[name=now]","#lineup").next().css( "color", "red" )
        $("[name=now]","#lineup").removeAttr("name style")
        $("[style='color: red;']","#lineup").attr("name","now")
      