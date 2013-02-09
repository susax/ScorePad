# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  # 初期バッターの設定 
  $("#top_lineup_1").attr("name","now_batter")
  $("#bottom_lineup_1").attr("name","next_batter")
  $("[name=now_batter]","#lineup").addClass("badge-important")
  # 初期イニングの設定
  $("#top_inning_1").attr("name","now_inning")
  $("#bottom_inning_1").attr("name","next_inning")
  $("[name=now_inning]","#game_score").addClass("badge-info")
  # 初期イニングの設定
  top_score = $("#top_score").text()
  top_score = parseInt(top_score)
  this_inning_score = 0
  bottom_score = $("#bottom_score").text()
  bottom_score = parseInt(bottom_score)
  strike_count = $("#strike").text()
  strike_count = parseInt(strike_count)
  ball_count = $("#ball").text()
  ball_count = parseInt(ball_count)
  out_count = $("#out").text()
  out_count = parseInt(out_count)

# プレイボールボタン
  $("#play_ball").click ->
    $(this).hide("fast")
    $(".action_button").show("fast")
    $("select").attr("disabled", "disabled")

# ストライクボタン
  $("#strike_add").click ->
    if strike_count is 2
      $("#dropped_third_strike").show("fast")    
    $("#strike_bottom ").show("fast")
    $(".action_button, .runner_action").children().attr("disabled", "disabled")  

# ストライク追加
  strike = ->
    if (strike_count is 2)
      count_reset()
      $("#batter_out").click()
    else
      $("#strike").text strike_count += 1

# 見逃しボタン
  $("#called_strike").click ->
    strike()
    $(".action_button, .runner_action").children().removeAttr("disabled")
    $("#strike_bottom").hide("fast")

# 空振りボタン
  $("#swing").click ->
    strike()
    $(".action_button, .runner_action").children().removeAttr("disabled")
    $("#strike_bottom").hide("fast")

# 振り逃げ
  $("#dropped_third_strike").click ->
    count_reset()
    advance()
    $(".action_button, .runner_action").children().removeAttr("disabled")
    $("#strike_bottom, #dropped_third_strike").hide("fast")

# ヒットキャンセル
  $("#hit_cancel").click ->
    $(".action_button").children().removeAttr("disabled")
    $("#hit_select").hide("fast")

# ファールボタン
  $("#fall").click ->
    if (strike_count < 2) 
      $("#strike").text strike_count += 1

# ボールボタン
  $("#ball_add").click ->
    if (ball_count is 3)
      count_reset()
      advance()
    else
      $("#ball").text ball_count += 1

# バッターアウトボタン
  $("#batter_out").click ->      
    count_reset()
    # 今の打順を取得
    now_lineup = $("[name=now_batter]","#lineup").index()
    if (out_count is 2)
      $("#out").text out_count -= 2
      runner_reset()
      runner_action_hide()
      inning_count = $("#inning").text()
      inning_count = parseInt(inning_count)
      top_or_bottom = $("#top_or_bottom").text()
      $("[name=next_inning]","#game_score").addClass("badge-info")
      $("[name=now_inning]","#game_score").next().attr("name","next_inning")
      $("[name=now_inning]","#game_score").removeAttr("name").removeClass("badge-info")
      $("[class*=badge-info]","#game_score").attr("name","now_inning").text this_inning_score = 0
      $("[name=next_batter]","#lineup").addClass("badge-important")
      # 打順が9番だったら1番に
      if (now_lineup is 9)
        $("[name=now_batter]","#lineup").parent().children().eq(1).attr("name","next_batter")
        lineup_next_now()
      else
        $("[name=now_batter]","#lineup").next().attr("name","next_batter")
        lineup_next_now()
      if (top_or_bottom is "回表")
        $("#top_or_bottom").text "回裏"
      else
        $("#inning").text inning_count += 1
        $("#top_or_bottom").text "回表"
    else
      $("#out").text out_count += 1
      if (now_lineup is 9)
        $("[name=now_batter]","#lineup").parent().children().eq(1).addClass("badge-important")
        lineup_next_now()
      else
        $("[name=now_batter]","#lineup").next().addClass("badge-important")
        lineup_next_now()

# アウト追加（バッター以外）
  out_add = ->     
    $("#strike").text strike_count = 0
    $("#ball").text ball_count = 0
    if (out_count is 2)
      $("#out").text out_count -= 2
      count_reset()
      runner_reset()
      runner_action_hide()
      inning_count = $("#inning").text()
      inning_count = parseInt(inning_count)
      top_or_bottom = $("#top_or_bottom").text()
      $("[name=next_inning]","#game_score").addClass("badge-info")
      $("[name=now_inning]","#game_score").next().attr("name","next_inning")
      $("[name=now_inning]","#game_score").removeAttr("name").removeClass("badge-info")
      $("[class*=badge-info]","#game_score").attr("name","now_inning").text this_inning_score = 0
      $("[name=next_batter]","#lineup").addClass("badge-important")
      $("[name=now_batter]","#lineup").attr("name","next_batter").removeClass("badge-important")
      $("[class*=badge-important]","#lineup").attr("name","now_batter")
      if (top_or_bottom is "回表")
        $("#top_or_bottom").text "回裏"
      else
        $("#inning").text inning_count += 1
        $("#top_or_bottom").text "回表"
    else
      $("#out").text out_count += 1

# デッドボール
  $("#hit_by_pitch").click ->
    advance()

# ランナーアクション表示
  runner_action_show = ->
    $(".runner_action").show("fast")

# ランナーアクション非表示
  runner_action_hide = ->
    $(".runner_action").hide("fast")

# ランナースタートのキャンセル
  $("button[class*=record]").click ->
    $("button[class*=active]").removeClass("active")

# 牽制アウト表示
  $("#pickoff_out").click ->
    $(".action_button, .runner_action").children().attr("disabled", "disabled") 
    runner = [$("#first_base_runner").text(), $("#second_base_runner").text(), $("#third_base_runner").text()]
    for i of runner
      if (runner[i] != "")
        $("#runner").children().children().eq(i).children().eq(2).children().show()

# 各塁の牽制アウト
  $(".runner_out").click ->
    $(this).parent().prev().text ""
    $("[class*=runner_out]","#runner").hide()
    $(".action_button, .runner_action").children().removeAttr("disabled")
    runner = [$("#first_base_runner").text(), $("#second_base_runner").text(), $("#third_base_runner").text()]
    if (runner[0] == "" ) and (runner[1] == "" ) and (runner[2] == "" )
      runner_action_hide()
    out_add()
    console.log(runner)

# ボーク
  $("#balk").click ->
    first_base_runner = $("#first_base_runner").text()
    second_base_runner = $("#second_base_runner").text()
    third_base_runner = $("#third_base_runner").text()
    if (third_base_runner != "")
      if ($("[name=now_batter]","#lineup").attr('id').match( /top_lineup/ ))
        $("#top_score").text top_score += 1
      else
        $("#bottom_score").text bottom_score += 1
      if (first_base_runner == "") and (second_base_runner == "")
        runner_action_hide()
      $("[name=now_inning]","#game_score").text this_inning_score += 1
    $("#third_base_runner").text second_base_runner
    $("#second_base_runner").text first_base_runner 
    $("#first_base_runner").text("")

# ヒットボタン
  $("#hit").click ->
    $("#hit_select").show("fast")
    $(".action_button").children().attr("disabled", "disabled")

# シングルヒット
  $("#single").click ->
    $(".action_button").children().removeAttr("disabled")
    $("#hit_select").hide("fast")
    advance()
    runner_action_show()

# ダブルヒット
  $("#double").click ->
    batter = $("[class*=badge-important]","#lineup").children().eq(0).text().slice(0,1)
    first_base_runner = $("#first_base_runner").text()
    second_base_runner = $("#second_base_runner").text()
    third_base_runner = $("#third_base_runner").text()
    if (third_base_runner != "") and (second_base_runner != "") and (first_base_runner != "")
      if ($("[name=now_batter]","#lineup").attr('id').match( /top_lineup/ ))
        $("#top_score").text top_score += 2
      else
        $("#bottom_score").text bottom_score += 2
      $("#third_base_runner").text first_base_runner
      $("[name=now_inning]","#game_score").text this_inning_score += 2
    else if (third_base_runner != "") and (second_base_runner != "")
      if ($("[name=now_batter]","#lineup").attr('id').match( /top_lineup/ ))
        $("#top_score").text top_score += 1
      else
        $("#bottom_score").text bottom_score += 1
      $("#third_base_runner").text first_base_runner
      $("[name=now_inning]","#game_score").text this_inning_score += 1
    else if (third_base_runner != "") and (first_base_runner != "")
      if ($("[name=now_batter]","#lineup").attr('id').match( /top_lineup/ ))
        $("#top_score").text top_score += 1
      else
        $("#bottom_score").text bottom_score += 1
      $("#third_base_runner").text first_base_runner
      $("[name=now_inning]","#game_score").text this_inning_score += 1
    else if (second_base_runner != "") 
      $("#third_base_runner").text second_base_runner
    else if (first_base_runner != "")
      $("#third_base_runner").text first_base_runner
    $("#first_base_runner").text("")
    $("#second_base_runner").text batter
    lineup_next()
    count_reset()
    $(".action_button").children().removeAttr("disabled")
    $("#hit_select").hide("fast")
    runner_action_show()

# トリプルヒット
  $("#triple").click ->
    batter = $("[class*=badge-important]","#lineup").children().eq(0).text().slice(0,1)
    first_base_runner = $("#first_base_runner").text()
    second_base_runner = $("#second_base_runner").text()
    third_base_runner = $("#third_base_runner").text()
    score = 0
    if (first_base_runner != "")
      score += 1
    if (second_base_runner != "")
      score += 1
    if (third_base_runner != "")
      score += 1
    if ($("[name=now_batter]","#lineup").attr('id').match( /top_lineup/ ))
        $("#top_score").text top_score += score
      else
        $("#bottom_score").text bottom_score += score
    $("[name=now_inning]","#game_score").text this_inning_score += score
    runner_reset()
    $("#third_base_runner").text batter
    lineup_next()
    count_reset()
    $(".action_button").children().removeAttr("disabled")
    $("#hit_select").hide("fast")
    runner_action_show()

# ヒットキャンセル
  $("#hit_cancel").click ->
    $(".action_button").children().removeAttr("disabled")
    $("#hit_select").hide("fast")

# ホームラン
  $("#home_run").click ->
    first_base_runner = $("#first_base_runner").text()
    second_base_runner = $("#second_base_runner").text()
    third_base_runner = $("#third_base_runner").text()
    score = 1
    if (first_base_runner != "")
      score += 1
    if (second_base_runner != "")
      score += 1
    if (third_base_runner != "")
      score += 1
    if ($("[name=now_batter]","#lineup").attr('id').match( /top_lineup/ ))
        $("#top_score").text top_score += score
      else
        $("#bottom_score").text bottom_score += score
    $("[name=now_inning]","#game_score").text this_inning_score += score
    lineup_next()
    runner_reset()
    count_reset()
    runner_action_hide()

# カウントリセット
  count_reset = ->
    $("#strike").text strike_count = 0
    $("#ball").text ball_count = 0

# 打順移動におけるnow_batterの付け替え
  lineup_next_now = ->
    $("[name=now_batter]","#lineup").removeAttr("name").removeClass("badge-important")
    $("[class*=badge-important]","#lineup").attr("name","now_batter")

# 同じ攻撃での打順移動
  lineup_next = ->
    now_lineup = $("[name=now_batter]","#lineup").index()
    if (now_lineup is 9)
      $("[name=now_batter]","#lineup").parent().children().eq(1).addClass("badge-important")
      lineup_next_now()
    else
      $("[name=now_batter]","#lineup").next().addClass("badge-important")
      lineup_next_now()

# 塁上リセット
  runner_reset = ->
    $("#first_base_runner").text("")
    $("#second_base_runner").text("")
    $("#third_base_runner").text("") 

# 最低進塁アクション
  advance = ->
    batter = $("[class*=badge-important]","#lineup").children().eq(0).text().slice(0,1)
    first_base_runner = $("#first_base_runner").text()
    second_base_runner = $("#second_base_runner").text()
    third_base_runner = $("#third_base_runner").text()
    now_inning = $("#inning").text()
    if (third_base_runner != "") and (second_base_runner != "") and (first_base_runner != "")
      if ($("[name=now_batter]","#lineup").attr('id').match( /top_lineup/ ))
        $("[name=now_inning]","#game_score").text this_inning_score += 1
        $("#top_score").text top_score += 1
      else
        $("[name=now_inning]","#game_score").text this_inning_score += 1
        $("#bottom_score").text bottom_score += 1
      $("#third_base_runner").text second_base_runner
      $("#second_base_runner").text first_base_runner
    else if (second_base_runner != "") and (first_base_runner != "")
      $("#third_base_runner").text second_base_runner
      $("#second_base_runner").text first_base_runner
    else if (third_base_runner != "") and (first_base_runner != "")
      $("#second_base_runner").text first_base_runner
    else if (first_base_runner != "")
      $("#second_base_runner").text first_base_runner
    $("#first_base_runner").text batter
    lineup_next()
    count_reset()
    runner_action_show()