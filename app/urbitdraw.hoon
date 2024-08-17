/-  urbitdraw, pals
/+  dbug, default-agent, server, schooner
/*  ui  %html  /app/urbitdraw/html
::
|%
::
+$  versioned-state  $%(state-0)
::
+$  state-0  [%0 =canvas:urbitdraw]
::
+$  card  card:agent:gall
--
::
%-  agent:dbug
=|  state-0
=*  state  -
::
^-  agent:gall
::
=<
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %|) bowl)
    hc   ~(. +> [bowl ~])
::
++  on-init
  ^-  (quip card _this)
  =^  cards  state  abet:init:hc
  [cards this]
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  =vase
  ^-  (quip card _this)
  =^  cards  state  abet:(load:hc vase)
  [cards this]
::
++  on-poke
  |=  =cage
  ^-  (quip card _this)
  =^  cards  state  abet:(poke:hc cage)
  [cards this]
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  [~ ~]
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  `this
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  `this
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  =^  cards  state  abet:(watch:hc path)
  [cards this]
::
++  on-fail   on-fail:def
++  on-leave  on-leave:def
--
::
|_  [=bowl:gall deck=(list card)]
+*  that  .
::
++  emit  |=(=card that(deck [card deck]))
++  emil  |=(lac=(list card) that(deck (welp lac deck)))
++  abet  ^-((quip card _state) [(flop deck) state])
::
++  init
  ^+  that
  %-  emit
  :*  %pass   /eyre/connect   
      %arvo  %e  %connect
      `/apps/urbitdraw  %urbitdraw
  ==
::
++  load
  |=  =vase
  ^+  that
  ?>  ?=([%0 *] q.vase)
  that(state !<(state-0 vase))
::
++  watch
  |=  =path
  ^+  that
  ?+    path  that
      [%http-response *]
    that
  ==
:: 
++  poke
  |=  =cage
  ^+  that
  ?+    -.cage  !!
      %handle-http-request
    (handle-http !<([@ta =inbound-request:eyre] +.cage))
  ==
::
++  draw
  |=  pix=pixels:urbitdraw
  ^+  that
  =/  rank  (get-rank src.bowl)
  ?:  =('comet' rank)  !!
  ::
  =/  lowest=@ud
    =<  +
    %^    spin
        pix
      999
    |=  [p=[[x=@ud y=@ud] color=@t] lowest=@ud]
    [p (min y.p lowest)]
  ::
  ?:  ?|  ?&  =('star' rank)
              (lth lowest 212)
          ==
          ?&  =('planet' rank)
              (lth lowest 106)  :: "lowest" aka highest value ui allows
          ==
      ==
    !!
  ::
  that(canvas (~(gas by canvas) pix))
::
++  handle-http
  |=  [eyre-id=@ta =inbound-request:eyre]
  ^+  that
  =/  ,request-line:server
    (parse-request-line:server url.request.inbound-request)
  =+  send=(cury response:schooner eyre-id)
  ::
  ?+    method.request.inbound-request
    (emil (flop (send [405 ~ [%stock ~]])))
    ::
      %'POST'
    ?~  body.request.inbound-request  !!
    =/  json  (de:json:html q.u.body.request.inbound-request)
    =/  pix  (dejs-action +.json)
    (draw pix)
    ::
      %'GET'
    %-  emil
    %-  flop
    %-  send
    ?+    site  [404 ~ [%plain "404 - Not Found"]]
    ::
        [%apps %urbitdraw ~]
      [200 ~ [%html ui]]
    ::
        [%apps %urbitdraw %state ~]
      [200 ~ [%json (enjs-state canvas)]]
    ::
        [%apps %urbitdraw %eauth ~]
      [302 ~ [%login-redirect '/apps/urbitdraw&eauth']] 
    ==
  ==
::
++  enjs-state
  =,  enjs:format
  |=  =canvas:urbitdraw
  ^-  json
  %-  pairs
  :~  [%rank [%s (get-rank src.bowl)]]
      :-  %pixels
      :-  %a
      %+  turn
        ~(tap by canvas)
      |=  [[x=@ud y=@ud] color=@t]
      :-  %a
      :~  (numb x)
          (numb y)
          [%s color]
      ==
  ==
::
++  dejs-action
  =,  dejs:format
  |=  jon=json
  ^-  pixels:urbitdraw
  %.  jon
  (ar (ot ~[coords+(ot ~[x+ni y+ni]) color+so]))
::
++  get-rank
  |=  who=@p
  ^-  @t
  ?:  (gth src.bowl 0xffff.ffff)
    'comet'
  ?:  (gth src.bowl 0xffff)
    'planet'
  ?:  (gth src.bowl 0xff)
    'star'
  'galaxy'
--