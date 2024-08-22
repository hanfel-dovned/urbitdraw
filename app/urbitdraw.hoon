/-  ud=urbitdraw, pals
/+  dbug, default-agent, server, schooner, ethereum, naive
/*  ui  %html  /app/urbitdraw/html
::
|%
+$  versioned-state  $%(state-0 state-1)
+$  state-0  [%0 =canvas:ud]
+$  state-1  [%1 =canvas:ud =sessions:ud =challenges:ud]
+$  card  card:agent:gall
--
::
%-  agent:dbug
=|  state-1
=*  state  -
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
  =/  old  !<(versioned-state vase)
  ?-  -.old
    %1  that(state old)
    %0  that(state [%1 canvas.old ~ ~])
  ==
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
::  If eauthed in, use that. 
::  Else, check for mask auth. 
++  get-id
  ^-  @p
  ?:  ?!(=('comet' (get-rank src.bowl)))
    src.bowl
  =/  authed  (~(got by sessions) src.bowl)
  ?:  ?!(=('comet' (get-rank authed)))
    authed
  src.bowl
::
::  Get y-coord of lowest pixel, reject if it's out of bounds.
++  draw
  |=  pix=pixels:ud
  ^+  that
  =/  id  get-id
  =/  rank  (get-rank id)
  ?:  =('comet' rank)
    !!
  =/  lowest=@ud
    =<  +
    %^    spin
        pix
      999
    |=  [p=[[x=@ud y=@ud] color=@t] lowest=@ud]
    [p (min y.p lowest)]
  ?:  ?|  ?&  =('star' rank)
              (lth lowest 53)
          ==
          ?&  =('planet' rank)
              (lth lowest 106)
          ==
      ==
    !!
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
    =/  act  (dejs-action +.json)
    ?-    -.act
        %draw
      (draw pixels.act)
    ::
        %auth
      ?.  (validate +.act)
        !!
      =.  sessions
        (~(put by sessions) [src.bowl who.act])
      %-  emil
      %-  flop
      %-  send
      [200 ~ [%html ui]]
    ==
    ::
      %'GET'
    ::  If this is a new comet, record them.
    ::  If they haven't mask-authed, create a new challenge.
    =?    sessions
        !(~(has by sessions) src.bowl)
      (~(put by sessions) [src.bowl src.bowl])
    =/  new-challenge  (sham [now eny]:bowl)
    =?    challenges
        =(src.bowl (~(got by sessions) src.bowl))
      (~(put in challenges) new-challenge)
    %-  emil  %-  flop  %-  send
    ?+    site  [404 ~ [%plain "404 - Not Found"]]
    ::
        [%apps %urbitdraw ~]
      [200 ~ [%html ui]]
    ::
        [%apps %urbitdraw %state ~]
      [200 ~ [%json (enjs-state [canvas new-challenge])]]
    ::
        [%apps %urbitdraw %eauth ~]
      [302 ~ [%login-redirect '/apps/urbitdraw&eauth']] 
    ==
  ==
::
++  enjs-state
  =,  enjs:format
  |=  [=canvas:ud challenge=secret:ud]
  ^-  json
  %-  pairs
  :~  [%rank [%s (get-rank get-id)]]
      [%challenge [%s (scot %uv challenge)]]
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
  ^-  action:ud
  %.  jon
  %-  of
  :~  [%draw (ar (ot ~[coords+(ot ~[x+ni y+ni]) color+so]))]
      [%auth (ot ~[who+(se %p) secret+(se %uv) address+sa signature+sa])]
  ==
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
::
::  Modified from ~rabsef-bicrym's %mask
::  Validate that Owner of Who = Signer of Challenge
++  validate
  |=  [who=@p challenge=secret:ud address=tape hancock=tape]
  ^-  ?
  ~&  >  [who challenge address hancock]
  =/  addy  (from-tape address)
  =/  cock  (from-tape hancock)
  =/  owner  (get-owner who)
  ?~  owner
    .^(? %j /=fake=)  :: XX not sure this makes sense for signing into someone else's ship
  ?.  =(addy u.owner)  %.n
  ?.  (~(has in challenges) challenge)  %.n
  =/  note=@uvI
    =+  octs=(as-octs:mimes:html (scot %uv challenge))
    %-  keccak-256:keccak:crypto
    %-  as-octs:mimes:html
    ;:  (cury cat 3)
      '\19Ethereum Signed Message:\0a'
      (crip (a-co:co p.octs))
      q.octs
    ==
  ?.  &(=(20 (met 3 addy)) =(65 (met 3 cock)))  %.n
  =/  r  (cut 3 [33 32] cock)
  =/  s  (cut 3 [1 32] cock)
  =/  v=@
    =+  v=(cut 3 [0 1] cock)
    ?+  v  !!
      %0   0
      %1   1
      %27  0
      %28  1
    ==
  ?.  |(=(0 v) =(1 v))  %.n
  =/  xy
    (ecdsa-raw-recover:secp256k1:secp:crypto note v r s)
  =/  pub  :((cury cat 3) y.xy x.xy 0x4)
  =/  add  (address-from-pub:key:ethereum pub)
  =(addy add)
::
++  from-tape
  |=(h=tape ^-(@ux (scan h ;~(pfix (jest '0x') hex))))
::
++  get-owner
  |=  who=@p
  ^-  (unit @ux)
  =-  ?~  pin=`(unit point:naive)`-
        ~
      ?.  |(?=(%l1 dominion.u.pin) ?=(%l2 dominion.u.pin))
        ~
      `address.owner.own.u.pin
  .^  (unit point:naive)
    %gx
    /=azimuth=/point/who/noun
  ==
--