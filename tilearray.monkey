Strict
Import Mojo


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
End Class


Class MyApp Extends App
Field presentstate:AppState 
Field gamesize:Int = 10
Field tilesize:Int
Field match:Int
Field size:int

	
	Method OnCreate:Int()

		
		If DeviceWidth() > DeviceHeight()
			tilesize = DeviceHeight()/gamesize
			Else
			tilesize = DeviceWidth()/gamesize
		Endif
		
		'presentstate = New AppStateGame(tilesize,gamesize)

		presentstate = New AppStateStart(DeviceWidth()/16,DeviceHeight()/2)
		
		

		Return 0
	End Method
	
	Method OnUpdate:Int()
	
		Select presentstate.Update()
			Case RETVAL.startgame
				size = presentstate.gamesize
				presentstate = New AppStateGame(size,match)
			Case RETVAL.startgame3
				match = 3
				presentstate = New AppStateSize(tilesize,3)
			Case RETVAL.startgame4
				match = 4
				presentstate = New AppStateSize(tilesize,4)
			Case RETVAL.startgame5
				match = 5
				presentstate = New AppStateSize(tilesize,5)
			Case RETVAL.winner_p1 
				Print "Player 1 Wins"
			Case RETVAL.winner_p2
				Print "Player 2 Wins"
			Case RETVAL.retry 
				presentstate = New AppStateStart(DeviceWidth()/16,DeviceHeight()/2)			
		End Select

		Return 0
	End Method
	
	Method OnRender:Int()
		Cls(0,0,0)
		presentstate.Render

		Return 0
	End Method
	

End Class

Class AppState 
	Field gamesize:float

'	Method Create:int() abstract
	
	
	Method Update:Int() Abstract
	
	Method Render:Int() Abstract


End Class
 
 
Class AppStateStart Extends AppState
	Field threeplayer:Grid
	Field fourplayer:Grid
	Field fiveplayer:Grid
	Field tilesize:Int




	Method New(tilesize:Int,offy:Int)
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


	Method New(tilesize:int,matches:int)
		Self.tilesize = tilesize
		Self.matches = matches
		
		grid1 = New Grid(matches,matches,tilesize*3/matches,tilesize,DeviceHeight()/2-1.5*tilesize)
		grid2 = New Grid(matches*2,matches*2,tilesize*3/matches/2,tilesize*5,DeviceHeight()/2-1.5*tilesize) 
		grid3 = New Grid(matches*3,matches*3,tilesize*3/matches/3,tilesize*9,DeviceHeight()/2-1.5*tilesize)
	

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
  			endif
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
	Field p1:= New Piece(40,40,100)
	Field p2:= New Piece(255,0,100)
	Field maskpiece:= New MaskPiece(0,0,0)
	Field currentplayer:Piece  
	Field Shortestside:Int


	Field offx:float
	Field offy:Int = 0
	Field solutions:List<Grid> 
	
	field gameover:Bool = false

	Field completematch:Grid
 
	Field tilesize:Float


	Field myboard:Grid  

	Method New(gamesize:Int,matches:Int)
	'	Self.tilesize = tilesize
		Self.gamesize = gamesize
		Self.tilesize = DeviceHeight()/gamesize

		Local soffx:Int
		Local soffy:Int = DeviceHeight()/2-tilesize
		soffx = DeviceWidth()/2-(3/2*tilesize)

		
		


		

			
		offx = (DeviceWidth()/2-(gamesize/2*tilesize))
		
'		threeplayer = New Grid(3,1,tilesize,DeviceWidth()/2-(3/2*tilesize),soffy)
'		fourplayer = New Grid(4,1,tilesize,DeviceWidth()/2-(4/2*tilesize),soffy+tilesize)
'		fiveplayer = New Grid(5,1,tilesize,DeviceWidth()/2-(5/2*tilesize),soffy+2*tilesize)
 





		SetUpdateRate(60) 	
' 
		myboard = New Grid(gamesize,gamesize,tilesize,offx,offy)


		solutions = CreateSolutions(matches,tilesize)
'		myboard.AddPiece(1,1,p1)
'		myboard.AddPiece(2,1,p1) 
		currentplayer = p1
		
		myboard.AddPiece(1,1,maskpiece)

		
	End Method
	
	Method Update:Int()
		
 		If TouchHit(0)

 	'			myboard.AddPiece(TouchX(0),TouchY(0),currentplayer)
			If gameover = false
 				If myboard.AddPiece(TouchX(0),TouchY(0),currentplayer)= true 
			
					completematch = CompleteMatchFound(currentplayer)
					
					If currentplayer = p1
						currentplayer = p2
						Else
						currentplayer = p1
					Endif
				
				Endif 			
			Endif		
			
			If gameover = True
				Return RETVAL.retry
			endif
				
 					
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
	
		Return 0
	End Method
	
	Method Render:Int() 
		Cls(currentplayer._r,currentplayer._g,currentplayer._b)
'		mygrid.Render

	
		myboard.Render
		If completematch 
			completematch.Render
			gameover = True
		Endif
		'For Local n:= Eachin solutions
			
			'n.Render
		
		'Next
 

		Return 0
	End Method
	
		Method CompleteMatchFound:Grid(p:Piece)
		For Local s:= Eachin solutions
			For Local by:Int = 0 to myboard._sy - s._sy
				For Local bx:Int = 0 to myboard._sx - s._sx
					Local match:Bool = True
					For Local sy:Int = 0 Until s._sy
						For Local sx:Int = 0 Until s._sx
							If s.pieces [s.I(sx,sy)]
								If myboard.pieces[myboard.I(bx+sx,by+sy)] <> p
						
									match = False
								Endif
							Endif
						Next
					
				Next
				s._offsetx=bx*myboard._tilesize+myboard._offsetx
				s._offsety=by*myboard._tilesize+myboard._offsety
				s.showgrid = false
				If match = True Return s
			Next
		Next
		next
		Return null
	End method


End Class


Class Piece 
 
 	Field piecetype:Int 
	Field _r:Int  
	Field _g:Int 
	Field _b:Int 

	Method New()
		
		piecetype = 0
		_r = 40'Rnd(0,255)
		_g = 40'Rnd(0,255)		
		_b = 40'Rnd(0,255)
	
	End Method
	
	Method New (r:Int,g:Int,b:Int)
		_r=r
		_g=g
		_b=b
	End Method

	Method Draw:Void(x:Float,y:Float,tilesize:Int)
		SetColor(_r,_g,_b)
		DrawCircle(x+tilesize/2,y+tilesize/2,tilesize/2)		
	End Method
	
	Method Update:Void()
		'Self.r = Rnd(0,255)
		'Self.g = Rnd(0,255)
		'Self.b = Rnd(0,255)	
	End Method


End Class

Class PieceSmiley Extends Piece

	Method New (r:Int,g:Int,b:Int)
		
		Super.New(r,g,b)
		
	End Method


	Method Draw:Void(x:Float,y:Float,tilesize:Int)
		SetColor(_r,_g,_b)
		DrawCircle(x+tilesize*0.25,y+tilesize*0.35,tilesize/5)	
		DrawCircle(x+tilesize*0.75,y+tilesize*0.35,tilesize/5)	
		
		DrawLine(x+tilesize*0.20,y+tilesize*0.65,x+tilesize*0.40,y+tilesize*0.85)
		DrawLine(x+tilesize*0.40,y+tilesize*0.85,x+tilesize*0.60,y+tilesize*0.85)
		DrawLine(x+tilesize*0.60,y+tilesize*0.85,x+tilesize*0.80,y+tilesize*0.65)


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
	Field showgrid:Bool = true
		
	Method New (sx:Int,sy:Int,tilesize:Int,offsetx:Int,offsety:Int)
		_sx = sx
		_sy = sy
		_tilesize = tilesize
		_offsetx = offsetx
		_offsety = offsety
		pieces = New Piece[_sx*_sy]
		

	End Method
	
	
	Method New()
	'	Error "Grid New() : Call the constructor with paremeters!"
	End Method
	
	
	
 
	
	Method Update:Void ()

	End Method
	
	
	Method Render:Void ()
	
		For Local y:Int = 0 Until _sy 
			For Local x:Int = 0  Until _sx 
			
				If showgrid 
					SetColor(255,255,255)
					
					If Not pieces[I(x,y)] Or pieces[I(x,y)].piecetype <> 1
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
	
End Class

Class Vec2i
	Field x:Int
	Field y:Int
	
	Method New (x:Int,y:Int)
		Self.x=x
		Self.y=y
	
	End Method


End Class

Function CreateSolutions:List<Grid>(size:Int,tilesize:Int)
	Local checkpiece:= New PieceSmiley(255,255,255)

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
