Strict
Import Mojo
#ANDROID_SCREEN_ORIENTATION = "landscape"
#ANDROID_APP_LABEL = "Match Anything"
#ANDROID_SIGN_APP = True
#ANDROID_APP_PACKAGE = "com.Arthur.MatchAnything"

Function Main:Int()

	Local theapp:MyApp = New MyApp

	Return 0	
End Function

Class RETVAL
	Const startgame:Int = 1
	Const startgame3:Int = 3
	Const startgame4:Int = 4
	Const startgame5:Int = 5
	Const winner_p1:Int = 6
	Const winner_p2:Int = 7
	Const retry:Int = 8
	Const close :int= 9
End Class

Class SHAPE
	Const none:Int = 0
	Const happy:Int = 1
	Const sad:Int = 2
	Const indifferent:Int = 3
	Const cross:Int = 4
	Const arrow:Int = 5
End Class


Class MyApp Extends App
Field presentstate:AppState 
Field gamesize:Int = 10
Field tilesize:Int
Field match:Int
Field size:Int
Field action:Int 

	
	Method OnCreate:Int()

		
		If DeviceWidth() > DeviceHeight()
			tilesize = DeviceHeight()/gamesize
			Else
			tilesize = DeviceWidth()/gamesize
		Endif
		
		'presentstate = New AppStateGame(tilesize,gamesize)

		presentstate = New AppStateStart(DeviceWidth()/16,(DeviceHeight()-tilesize)/2)
		Print "Off:" + ((DeviceHeight()-tilesize)/2)
		Print "DH:" + DeviceHeight()+tilesize 
		
		

		Return 0
	End Method
	
	Method OnUpdate:Int()
		
	
		Select presentstate.Update()
			Case RETVAL.startgame
				size = presentstate.gamesize
				presentstate = New AppStateGame(size,match)
				presentstate.action = 0
			Case RETVAL.startgame3
				match = 3
				presentstate = New AppStateSize(tilesize,3)
				presentstate.action = 0
			Case RETVAL.startgame4
				match = 4
				presentstate = New AppStateSize(tilesize,4)
				presentstate.action = 0
			Case RETVAL.startgame5
				match = 5
				presentstate = New AppStateSize(tilesize,5)
				presentstate.action = 0
			Case RETVAL.winner_p1 
				Print "Player 1 Wins"
			Case RETVAL.winner_p2
				Print "Player 2 Wins"
			Case RETVAL.retry 
				presentstate = New AppStateStart(DeviceWidth()/16,DeviceHeight()/2)		
			Case RETVAL.close
				OnClose()	
		End Select
		
		

		Return 0
	End Method
	
	Method OnRender:Int()
		Cls(0,0,0)
		presentstate.Render
'		If action = 1
'			Cls(255,0,0)
'		endif
		Return 0
	End Method
	
	
	Method OnBack:Int()
'		If presentstate.ID = 1
'			presentstate = New AppStateStart(DeviceWidth()/16,DeviceHeight()/2)
	'	if presentstate.ID = 2
'			presentstate.action = 1
			presentstate.action = 1
	'	Endif
						
		Return 0
	End Method

End Class

Class AppState 

	Field ID:Int 

	Field action:Int 
	Field gamesize:Float

'	Method Create:int() abstract
	
	
	Method Update:Int() Abstract
	
	Method Render:Int() Abstract


End Class
 
 
Class AppStateStart Extends AppState
	Const ID:Int = 0
	
	Field threeplayer:Grid
	Field fourplayer:Grid
	Field fiveplayer:Grid
	Field tilesize:Int
	



	Method New(tilesize:Int,offy:int)
		Self.tilesize = tilesize
		threeplayer = New Grid(3,1,tilesize,tilesize,offy)
		fourplayer = New Grid(4,1,tilesize,5*tilesize,offy)
		fiveplayer = New Grid(5,1,tilesize,10*tilesize,offy)
		
		
	End Method
	
	Method Update:Int()
		If TouchHit(0)
			If threeplayer.InsideMe(TouchX(0),TouchY(0))
				Return RETVAL.startgame3
			Elseif fourplayer.InsideMe(TouchX(0),TouchY(0))
				Return RETVAL.startgame4
			Elseif fiveplayer.InsideMe(TouchX(0),TouchY(0))
				Return RETVAL.startgame5
			Elseif action = 1
				Return RETVAL.close
			Endif
		Endif
		Return 0
	End Method
	
	Method Render:Int()
		Cls(0,0,0)
		threeplayer.Render
		fourplayer.Render
		fiveplayer.Render
		Return 0
	End Method




End Class


Class AppStateSize Extends AppState
	Field grid1:Grid
	Field grid2:Grid
	Field grid3:Grid
	Field tilesize:Int
	Field matches:Int
	Const ID:Int = 1


	Method New(tilesize:int,matches:int)
	'	Self.tilesize = tilesize
		Self.tilesize = DeviceWidth()/13
		Self.matches = matches
		
		grid1 = New Grid(matches,matches,Self.tilesize*3/matches,Self.tilesize,DeviceHeight()/2-1.5*Self.tilesize)
		grid2 = New Grid(matches*2,matches*2,Self.tilesize*3/matches/2,Self.tilesize*5,DeviceHeight()/2-1.5*Self.tilesize) 
		grid3 = New Grid(matches*3,matches*3,Self.tilesize*3/matches/3,Self.tilesize*9,DeviceHeight()/2-1.5*Self.tilesize)
	

  	End Method
  	
  	Method Update:Int()
  		If TouchHit(0)
  			If grid1.InsideMe(TouchX(0),TouchY(0))
  				gamesize = grid1._sx
  				Return RETVAL.startgame
  			Elseif grid2.InsideMe(TouchX(0),TouchY(0))
  				gamesize = grid2._sx
  				Return RETVAL.startgame
  			Elseif grid3.InsideMe(TouchX(0),TouchY(0))
  				gamesize = grid3._sx
  				Return RETVAL.startgame
  			Endif
  		Endif
  		If KeyHit(KEY_BACKSPACE)Or action = 1
  			Return RETVAL.retry
  		endif
  		Return 0
  	End Method

	Method MyGamesize:Int()
	Return gamesize
	End Method
	
	
	Method Render:int()
		grid1.Render
		grid2.Render
		grid3.Render
		
		Return 0
	End method


End class

Class AppStateGame Extends AppState
	Field ID:Int = 2

	Field p1:= New Piece(1,40,40,100)
	Field p2:= New Piece(2,255,0,100)
	Field maskpiece:= New MaskPiece(0,0,0)
	
	Field button_1:Piece
	Field button_2:Piece

	Field currentplayer:Piece  
	Field Shortestside:Int
	Field exitprompt:Grid


	Field offx:Float
	Field offy:Int = 0
	Field solutions:List<Grid> 
	
	Field gameover:Bool = False

	Field foundsolution:Grid
 
	Field tilesize:Float


	Field myboard:Grid  
	
	Field tie:Bool 

	Method New(gamesize:Float,matches:Int)
	'	Self.tilesize = tilesize
		Self.gamesize = gamesize
		Self.tilesize = DeviceHeight()/gamesize

		Local soffx:Int
		Local soffy:Int = DeviceHeight()/2-tilesize*0.5
		soffx = DeviceWidth()/2-(3/2*tilesize)
		
		button_1 = New Piece(0,0,200,0)
		button_2 = New Piece(0,200,0,0)
		button_1.piecetype = 2
		button_1.shape = SHAPE.arrow
		button_2.piecetype = 2
		button_2.shape = SHAPE.cross
		
'		exitprompt = New Grid(3,1,DeviceWidth()/8,DeviceHeight()/2-0.5*(DeviceWidth()/8),DeviceHeight()/2-0.5*(DeviceWidth()/8))

	'	exitprompt.AddPiece(exitprompt._offsetx+1,exitprompt._offsety+1,maskpiece)

'		exitprompt.AddPiece(exitprompt._offsetx+2*exitprompt._tilesize-1,exitprompt._offsety+1,maskpiece)

	'	exitprompt.AddPiece(exitprompt._offsetx+3*exitprompt._tilesize-1,exitprompt._offsety+1,maskpiece)
		

'		exitprompt.AddPiece(exitprompt._offsetx+1,exitprompt._offsety+1,button_1)
'		exitprompt.AddPiece(exitprompt._offsetx+3*exitprompt._tilesize-1,exitprompt._offsety+1,button_2)
		
		action = 1

		
'		If gamesize = 3
'			offx = (DeviceWidth()/2-(gamesize/2*tilesize))/2
'		Else
			offx = (DeviceWidth()/2-(gamesize/2*tilesize))
'		Endif
		
		Print "DeviceWidth:" + DeviceWidth()
		Print "gamesize:" + gamesize
		Print "tilesize:" + tilesize
		Print "offx:" + offx
		
'		threeplayer = New Grid(3,1,tilesize,DeviceWidth()/2-(3/2*tilesize),soffy)
'		fourplayer = New Grid(4,1,tilesize,DeviceWidth()/2-(4/2*tilesize),soffy+tilesize)
'		fiveplayer = New Grid(5,1,tilesize,DeviceWidth()/2-(5/2*tilesize),soffy+2*tilesize)
 





		SetUpdateRate(60) 	
' 
		myboard = New Grid(gamesize,gamesize,tilesize,offx,offy)
		currentplayer = p1

		solutions = CreateSolutions(matches,tilesize,currentplayer)
'		myboard.AddPiece(1,1,p1)
'		myboard.AddPiece(2,1,p1) 
		
'		If matches = 3 And gamesize = matches*3
'			myboard.AddPiece(offx,offy,maskpiece)
'			myboard.AddPiece(offx,offy,maskpiece)
'		endif
		
	End Method
	
	Method Update:Int()
		
		If KeyHit(KEY_BACKSPACE)
			action = 1
		
		Endif
		

		
 		If TouchHit(0)

 	'			myboard.AddPiece(TouchX(0),TouchY(0),currentplayer)

			If gameover = True
				Return RETVAL.retry
			Endif
	
			If gameover = False
 				If myboard.AddPiece(TouchX(0),TouchY(0),currentplayer.Clone())= True 
			
					foundsolution = CompleteMatchFound(currentplayer)
					If foundsolution 

						myboard.SetMood(foundsolution.GetPositions(),SHAPE.happy)
						gameover = True
					Endif
					
					If currentplayer = p1
						currentplayer = p2
						Else
						currentplayer = p1
					Endif
				
				Endif 	
				
				If exitprompt
 					If exitprompt.TileDown(TouchX(0),TouchY(0))=0
						Print "GREEN"
					'	gameover = True
						exitprompt = Null
						action = 0
						Return RETVAL.retry
					
				
					Elseif exitprompt.TileDown(TouchX(0),TouchY(0))=2
						Print "RED"
						exitprompt = Null
						myboard.standby = False
				'		Print "What's wrong?"
						action = 0
						Return 0
					Endif

			Endif		
					
			Endif		
			

				
 					
 		'		completematch = CompleteMatchFound(currentplayer) 


 				

				


		Endif	
		If KeyHit(KEY_R)
			p1._r = Rnd(0,255)
		Endif 

		If KeyHit(KEY_G)
			p1._g = Rnd(0,255)
		Endif
		
		If KeyHit(KEY_B)
			p1._b = Rnd(0,255)
		Endif
		
		If KeyHit(KEY_C)
			myboard.Clear
		Endif
		
		If KeyHit(KEY_P)

		Endif
		
		If action = 1
			myboard.standby = True 
	'		myboard = Null
			exitprompt = New Grid(3,1,DeviceWidth()/8,DeviceWidth()/2-1.5*(DeviceWidth()/8),DeviceHeight()/2-0.5*(DeviceWidth()/8))

			exitprompt.AddPiece(exitprompt._offsetx+2*exitprompt._tilesize-1,exitprompt._offsety+1,maskpiece)	
			
			exitprompt.AddPiece(exitprompt._offsetx+1,exitprompt._offsety+1,button_1)
			exitprompt.AddPiece(exitprompt._offsetx+3*exitprompt._tilesize-1,exitprompt._offsety+1,button_2)
			action = 0
		'	Return RETVAL.retry
		endif
		
		
'		For Local x:Int = 0Until gamesize 
'			Local istie:Bool = True
'			For Local y:Int = 0 Until gamesize 
'
	'			If Not myboard.pieces[myboard.I(x,y)]
	'				istie = False
	'			endif
	'		
	'		Next
	'		
	'		tie = istie
	'	next
	
 		
		
		
 			If tie = True
 				myboard.SetMood(myboard.GetPositions(),SHAPE.indifferent)
 				gameover = true
				'	Return RETVAL.retry
				
			Endif	
 				

		Return 0
	End Method
	
	Method Render:Int() 
		Cls(currentplayer._r,currentplayer._g,currentplayer._b)
'		mygrid.Render

	
		myboard.Render

		'For Local n:= Eachin solutions
			
			'n.Render
		
		'Next
 
		If exitprompt
			exitprompt.Render
		endif
		Return 0
	End Method
	
		Method CompleteMatchFound:Grid(p:Piece)
		For Local s:= Eachin solutions
		
			For Local by:Int = 0 To myboard._sy - s._sy

				For Local bx:Int = 0 To myboard._sx - s._sx

					Local match:Bool = True
					For Local sy:Int = 0 Until s._sy
						For Local sx:Int = 0 Until s._sx
							If s.pieces [s.I(sx,sy)]
								If myboard.pieces[myboard.I(bx+sx,by+sy)]<>null
									If myboard.pieces[myboard.I(bx+sx,by+sy)].ownerid <> p.ownerid
										match = False
									Endif 
								Else
									match = false
								Endif
							Endif
						Next
					
					Next
	'			s._offsetx=bx
	'			s._offsety=by
		
			
				s.showgrid = false
				If match = True 
					s.gridspacex=bx
					s.gridspacey=by		
				'	Print "bx "+bx
				'	Print "by "+by
					Return s
				endif
			Next

		Next
		Next
		tie = IsDraw()
		Return null
	End Method
	
	Method IsDraw:Bool()
		Local isdraw:Bool = False
		Local istie:int
	
		For Local x:Int = 0 Until myboard._sx
		'	Local istie:int
			For Local y:Int = 0 Until myboard._sy
				If  myboard.pieces[myboard.I(x,y)]
					istie += 1
					Print istie
				Endif
			Next
			If istie = myboard._sx*myboard._sy
				isdraw = True
			Endif
		
		Next
		
		
		Return isdraw
				
	
	
	End Method
End Class


Class Piece 
 
 	Field ownerid:int
 	Field piecetype:Int 
	Field _r:Int  
	Field _g:Int 
	Field _b:Int
	Field shape:int 

	Method New()
		
		piecetype = 0
		_r = 40'Rnd(0,255)
		_g = 40'Rnd(0,255)		
		_b = 40'Rnd(0,255)
	
	End Method
	
	Method New (ownerid:Int,r:Int,g:Int,b:Int)
		Self.ownerid = ownerid
		_r=r
		_g=g
		_b=b
	End Method

	Method Draw:Void(x:Float,y:Float,tilesize:Int)
		Shapes(x,y,tilesize,_r,_g,_b,shape)

'		SetColor(_r,_g,_b)
'		DrawCircle(x+tilesize/2,y+tilesize/2,tilesize/2)	
'		If shape = SHAPE.happy	
'			SetColor(255,255,255)
'			DrawEllipse(x+tilesize*0.5,y+tilesize*0.70,tilesize*0.4,tilesize*0.15)
'			SetColor(_r,_g,_b)
'			DrawEllipse(x+tilesize*0.5,y+tilesize*0.6,tilesize*0.4,tilesize*0.15)
'
'			SetColor(255,255,255)
'			DrawCircle(x+tilesize*0.25,y+tilesize*0.35,tilesize/5)	
'			DrawCircle(x+tilesize*0.75,y+tilesize*0.35,tilesize/5)	
'		Elseif shape = SHAPE.indifferent
'			SetColor(255,255,255)
'			DrawRect(x+tilesize/4,y+0.7*tilesize,tilesize/2,tilesize/8)
'			DrawCircle(x+tilesize*0.25,y+tilesize*0.35,tilesize/5)	
'			DrawCircle(x+tilesize*0.75,y+tilesize*0.35,tilesize/5)	
'		Endif
 		
	End Method
	
	Method Update:Void()
		'Self.r = Rnd(0,255)
		'Self.g = Rnd(0,255)
		'Self.b = Rnd(0,255)	
	End Method

	Method Clone:Piece()
		Local p:= New Piece(ownerid,_r,_g,_b)
		Return p
	End Method

End Class

Class PieceSmiley Extends Piece
	Field currentplayer:Piece
	Method New (r:Int,g:Int,b:Int,currentplayer:Piece)

		
		Super.New(0,r,g,b)

		Self.currentplayer = currentplayer		
	End Method


	Method Draw:Void(x:Float,y:Float,tilesize:int)

'		
'		DrawLine(x+tilesize*0.20,y+tilesize*0.65,x+tilesize*0.40,y+tilesize*0.85)
'		DrawLine(x+tilesize*0.40,y+tilesize*0.85,x+tilesize*0.60,y+tilesize*0.85)
'		DrawLine(x+tilesize*0.60,y+tilesize*0.85,x+tilesize*0.80,y+tilesize*0.65)
'		
'		DrawLine(x+tilesize*0.20,y+1+tilesize*0.65,x+tilesize*0.40,y+1+tilesize*0.85)
'		DrawLine(x+tilesize*0.40,y+1+tilesize*0.85,x+tilesize*0.60,y+1+tilesize*0.85)
'		DrawLine(x+tilesize*0.60,y+1+tilesize*0.85,x+tilesize*0.80,y+1+tilesize*0.65)
'		
'		DrawLine(x+tilesize*0.20,y+2+tilesize*0.65,x+tilesize*0.40,y+2+tilesize*0.85)
'		DrawLine(x+tilesize*0.40,y+2+tilesize*0.85,x+tilesize*0.60,y+2+tilesize*0.85)
'		DrawLine(x+tilesize*0.60,y+2+tilesize*0.85,x+tilesize*0.80,y+2+tilesize*0.65)
'		
		DrawEllipse(x+tilesize*0.5,y+tilesize*0.70,tilesize*0.4,tilesize*0.15)
		SetColor(currentplayer._r,currentplayer._g,currentplayer._b)
		DrawEllipse(x+tilesize*0.5,y+tilesize*0.6,tilesize*0.4,tilesize*0.15)

		SetColor(_r,_g,_b)
		DrawCircle(x+tilesize*0.25,y+tilesize*0.35,tilesize/5)	
		DrawCircle(x+tilesize*0.75,y+tilesize*0.35,tilesize/5)	


	End Method



End Class

Class MaskPiece Extends Piece

	Method New(r:int,g:int,b:int)
	
	
		_r = r
		_g = g
		_b = b
		piecetype = 1
	End Method
	
End Class

Class Grid
	Field _sx:Int 
	Field _sy:Int 
	'Field myboxes:Box[]
	Field teamsize:Int = 10
	Field pieces:Piece[]
	Field _tilesize:Int
	Field _offsetx:Int
	Field _offsety:Int
	Field showgrid:Bool = True
	Field gridspacex:Int
	Field gridspacey:Int
	Field standby:Int = false
		
	Method New (sx:Int,sy:Int,tilesize:Int,offsetx:Int,offsety:Int)
		_sx = sx
		_sy = sy
		_tilesize = tilesize
		_offsetx = offsetx
		_offsety = offsety
		pieces = New Piece[_sx*_sy]
		

	End Method
	
	
'	Method New()
	'	Error "Grid New() : Call the constructor with paremeters!"
'	End Method
	
	
	
 
	
	Method Update:Void ()

	End Method
	
	
	Method Render:Void ()
	
		For Local y:Int = 0 Until _sy 
			For Local x:Int = 0  Until _sx 
			
				If showgrid 
					SetColor(255,255,255)
					
					If Not pieces[I(x,y)] Or pieces[I(x,y)].piecetype <1 Or pieces[I(x,y)].piecetype > 2
						DrawRect(x*_tilesize+1+_offsetx,y*_tilesize+1+_offsety,_tilesize-2,_tilesize-2)
					endif
				Endif
				
				If pieces[I(x,y)] And pieces[I(x,y)].piecetype <> 1
					pieces[I(x,y)].Draw(x*_tilesize+_offsetx,y*_tilesize+_offsety,_tilesize)
	 
			
				Endif

			Next	
			
		Next
		
'		For Local n:Int = 0 Until pieces.Length
'			pieces[n].Create(tilesize)
'		
'		Next
	
	End Method
	
	Method I:Int(x:Int,y:Int)
		
		
		
		Return y*_sx+x
	End Method
	
	Method AddPiece:Bool (x:Int,y:Int,p:Piece)
		Local gpos:= Screen2Me(x,y)
			'If gpos = Null Return False 
		'	Print gpos.x + "," + gpos.y
		If Screen2Me(x,y) = Null Return False
		If standby = True Return false

 			Return AddPieceCore(gpos.x,gpos.y,p)

	End Method
	
		Method AddPieceCore:Bool (x:Int,y:Int,p:Piece)
		
			'If gpos = Null Return False 

		
		If pieces[I(x,y)]
			Return False
			Else
			pieces[I(x,y)] = p
			Return True
		Endif

	End Method
	Method Clear:Void()
		pieces = New Piece[_sx*_sy]
	
	End Method
	
	Method Screen2Me:Vec2i(x:Int,y:Int)
		Local myx:Int = (x-_offsetx)/_tilesize
		Local myy:Int = (y-_offsety)/_tilesize
		If myx < 0 Or myx > _sx -1
			Return Null
		Endif
		If myy < 0 Or myy > _sy -1
			Return Null
		Endif
		
		Return New Vec2i((x-_offsetx)/_tilesize,(y-_offsety)/_tilesize)
	End Method
	
	Method InsideMe:Bool(x:Int,y:Int)
		
		If x < _offsetx Return False
		If y < _offsety Return False
		If x > _offsetx + _tilesize*_sx Return False
		If y > _offsety + _tilesize*_sy Return False
		Return true
		
	
	
	End Method
	
	Method TileDown:Int(x:Int,y:Int)
	
		If Screen2Me(x,y) = Null Return -1
		Local tileindex:Int = I(Screen2Me(x,y).x,Screen2Me(x,y).y)
		
		
	
		Return tileindex
	
	End Method
	
	Method GetPositions:List<Vec2i>()
		Local positions:= New List<Vec2i>
		
		For Local x:Int = 0 Until _sx
			For Local y:Int = 0 Until _sy
				If pieces[I(x,y)] 
					positions.AddLast(New Vec2i(x+gridspacex,y+gridspacey))
				Endif
			Next
		Next
		Return positions
	End Method
	
	
	Method SetMood:Void (positions:List<Vec2i>,shape:int)
		For Local pos:= Eachin positions



			Local p:= pieces[I(pos.x,pos.y)]
			If p
			
				Print "posx" + pos.x			
				Print "posy" + pos.y
				p.shape = shape
			Endif
		Next
	
	
	End Method
End Class

Class Prompt Extends Grid

	Field button_1:Piece
	Field button_2:Piece

	Method New()

		_sx = 3
		_sy = 1
		_tilesize = DeviceWidth()/8
		_offsetx = DeviceWidth()/2-1.5*_tilesize
		_offsety = DeviceHeight()/2-0.5*_tilesize
		button_1 = New Piece(0,0,200,0)
		button_2 = New Piece(0,200,0,0)
'		button_1.piecetype = 1
'		button_1.piecetype = 1
		pieces = New Piece[3]
		AddPiece(_offsetx+1,_offsety+1,button_1)
		AddPiece(_offsetx+3*_tilesize-1,_offsety+1,button_2)

	
	
	End method

	Method IsButtonClick:Int(x:Int,y:Int)
		If x > _offsetx And x < _offsetx+_tilesize And y > _offsety And y < _offsety+_tilesize Return 1

		If x > _offsetx+2*_tilesize And x < _offsetx+3*_tilesize And y > _offsety And y < _offsety+_tilesize Return 2
		
		Return 0
	
	
	End Method

End Class


Class Vec2i
	Field x:Int
	Field y:Int
	
	Method New (x:Int,y:Int)
		Self.x=x
		Self.y=y
	
	End Method


End Class

Function CreateSolutions:List<Grid>(size:Int,tilesize:Int,currentplayer:Piece)
	Local checkpiece:= New PieceSmiley(255,255,255,currentplayer)

	Local glist:= New List<Grid>
	Local ga:= New Grid(size,1,tilesize,0,0)
	
	
		For Local n:Int = 0 Until size
			ga.AddPieceCore(n,0,checkpiece)	
			Print n
		Next
		
		glist.AddLast(ga)	

	

	Local gb:= New Grid(1,size,tilesize,120,0)
	glist.AddLast(gb)
	Local gc:= New Grid(size,size,tilesize,200,0)
	glist.AddLast(gc)
	Local gd:= New Grid(size,size,tilesize,340,0)
	glist.AddLast(gd)
		
		
		For Local n:Int = 0 Until size
			gb.AddPieceCore(0,n,checkpiece)
		Next
		
		For Local n:Int = 0 Until size
			gc.AddPieceCore(n,n,checkpiece)
		Next
		
		For Local n:Int = 0 Until size '- 1 Until 0 Step -1
			gd.AddPieceCore(size-n-1,n,checkpiece)
		Next	
	

	Return glist
End Function

Function Shapes:Int(x:Float,y:Float,tilesize:Int,_r:Int,_g:Int,_b:Int,shape:Int)
	Local rot:Float = 45

	If shape >= SHAPE.none And shape <= SHAPE.indifferent
		SetColor(_r,_g,_b)
		DrawCircle(x+tilesize/2,y+tilesize/2,tilesize/2)	
	endif
		If shape = SHAPE.happy	
			SetColor(255,255,255)
			DrawEllipse(x+tilesize*0.5,y+tilesize*0.70,tilesize*0.4,tilesize*0.15)
			SetColor(_r,_g,_b)
			DrawEllipse(x+tilesize*0.5,y+tilesize*0.6,tilesize*0.4,tilesize*0.15)

			SetColor(255,255,255)
			DrawCircle(x+tilesize*0.25,y+tilesize*0.35,tilesize/5)	
			DrawCircle(x+tilesize*0.75,y+tilesize*0.35,tilesize/5)	
		Elseif shape = SHAPE.indifferent
			SetColor(255,255,255)
			DrawRect(x+tilesize/4,y+0.7*tilesize,tilesize/2,tilesize/8)
			DrawCircle(x+tilesize*0.25,y+tilesize*0.35,tilesize/5)	
			DrawCircle(x+tilesize*0.75,y+tilesize*0.35,tilesize/5)	
		Elseif shape = SHAPE.cross
			SetColor(_r,_g,_b)
			PushMatrix()
			'	Translate(-x,-y)
		'		Rotate(10)
				Translate(x+tilesize*0.5,y+tilesize*0.5)	
				Rotate(45)			
					DrawRect(-tilesize*0.5,-tilesize*0.5+tilesize/2-tilesize/6,tilesize,tilesize/3)
					DrawRect(-tilesize*0.5+tilesize/2-tilesize/6,-tilesize*0.5,tilesize/3,tilesize)
				
			PopMatrix()
		Elseif shape = SHAPE.arrow
			SetColor(_r,_g,_b)
			DrawRect(x+0.2*tilesize,y+0.5*tilesize-tilesize/6,tilesize,tilesize/3)
			PushMatrix()
				Translate(x,y+tilesize*0.5)
				Rotate(45)
					DrawRect(0,0,0.7*tilesize,tilesize/3)	
				Rotate(270)
					DrawRect(0,0-tilesize/3,0.7*tilesize,tilesize/3)
			PopMatrix()
			
		
		Endif
		

		Return 0

End Function 


#rem
Class Piece
	Field x:Float 
	Field y:float = 0.5
	Field color:Int

	Method Create:Void (tilesize:Int)
	
		
	'	SetColor(255,255,255)
				
		'DrawCircle(x*tilesize,y*tilesize,tilesize)
	'	DrawCircle(x*tilesize,y*tilesize,tilesize/2)
		
		
		
	End Method


End Class
#end
