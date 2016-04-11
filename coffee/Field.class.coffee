class Field
  fieldCards:[]

  constructor:(fieldCardArray, @isSame, @isPlus, @isWallSame)->
    for card in FieldCardArray
      if card is null
        @fieldCards.push null
      else
        [cardNum, playerNum] = card
        @fieldCards.push(new Card(cardNum, playerNum))

  getCard:(index)->
    unless 0 <= index <= 9
      if @isWallSame
        return new Card(999, 0)
      else
        return null
    @fieldCards[index]

  getPoint:()->
    point = 0
    for card in @fieldCards
      continue if card is null
      if card.playerNum() is 0
        point++
      else
        point--
    point


  put:(index, cardNum, playerNum)->
    x = index % 3
    y = index // 3
    u = @getCard(index-3)
    l = if x is 0 then new Card(999, 0) else @getCard(index-1)
    r = if x is 2 then new Card(999, 0) else @getCard(index+1)
    d = @getCard(index+3)
    card = new Card(cardNum, playerNum)
    isTurn =
      u : false
      l : false
      r : false
      d : false
    # 上
    unless u is null
      isTurn.u = true if u.down() < card.up()
    # 左
    unless l is null
      isTurn.l = true if l.right() < card.left()
    # 右
    unless r is null
      isTurn.r = true if r.left() < card.right()
    # 下
    unless d is null
      isTurn.d = true if d.up() < card.down()
    # プラス
    if @isPlus
      ary = [
        [u, 'u', 'down', 'up']
        [l, 'l', 'right', 'left']
        [r, 'r', 'left', 'right']
        [d, 'd', 'up', 'down']
      ]
      for key in [0...ary.length]
        continue if ary[key] is null
        [targetObj, dir, targetDir, myDir] = ary[key]
        myTotal = targetObj[targetDir]() + card[myDir]()
        for key2 in [key+1...ary.length]
          continue if ary[key2] is null
          [targetObj2, dir2, targetDir2, myDir2] = ary[key]
          if myTotal is (targetObj2[targetDir2]() + card[myDir2]())
            isTurn[dir] = isTurn[dir2] = true
    # セイム
    if @isSame or @isWallSame
      ary = [
        [u, 'u', 'down', 'up']
        [l, 'l', 'right', 'left']
        [r, 'r', 'left', 'right']
        [d, 'd', 'up', 'down']
      ]
      sameAry = []
      for key in [0...ary.length]
        continue if ary[key] is null
        [targetObj, dir, targetDir, myDir] = ary[key]
        sameAry.push key if targetObj[targetDir]() is card[myDir]()
      if sameAry.length >= 2
        for v in ary
          [targetObj, dir, targetDir, myDir] = v
          isTurn[dir] = true

    # ひっくり返す
    for doTurn, dir in isTurn
      ary = {u:u, l:l, r:r, d:d}
      ary[dir].setPlayerNum(playerNum) if doTurn
