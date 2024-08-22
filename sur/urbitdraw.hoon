|%
+$  secret  @uv
+$  pixels  (list [[x=@ud y=@ud] color=@t])
+$  canvas  (map [x=@ud y=@ud] color=@t)
+$  sessions  (map comet=@p id=@p)
+$  challenges  (set secret)
+$  action  
  $%  [%draw =pixels]
      [%auth who=@p =secret address=tape signature=tape]
  ==
--