Strict
Import Mojo


Function Main:Int()

	Local theapp:MyApp = New MyApp

	Return 0	
End Function


Class MyApp Extends App
Field presentstate:GameState 

	
	Method OnCreate:Int()
		presentstate = New SecondState
		
		Return 0
	End Method
	
	Method OnUpdate:Int()
		presentstate.Update

		Return 0
	End Method
	
	Method OnRender:Int()
		presentstate.Render

		Return 0
	End Method
	

End Class

Class GameState 

	Method Create:int() abstract
	
	
	Method Update:Int() Abstract
	
	Method Render:Int() Abstract


End Class
 
 
Class FirstState Extends GameState
	Field threeplayer:Grid
	Field fourplayer:Grid
	Field fiveplayer:Grid




	Method Create:Int()
		threeplayer = New Grid(3,1,tilesize,0,0)
		fourplayer = New Grid(4,1,tilesize,0,tilesize)
		fiveplayer = New Grid(5,1,tilesize,0,2*tilesize)
		
		Return 0
	End Method
	
	Method Update:Int()
	
		Return 0
	End Method
	
	Method Render:Int()
		threeplayer.Render
		fourplayer.Render
		fiveplayer.Render
		Return 0
	End Method




End Class


Class SecondState Extends GameState
	Field p1:= New Piece(40,40,100)
	Field p2:= New Piece(255,0,100)
	Field currentplayer:Piece  
	Field Shortestside:Int
	Field gamesize:Int = 10
	Field offx:Int
	Field offy:Int = 0
	Field solutions:List<Grid> 

 
	Field tilesize:Int 

	Field myboard:Grid  

	Method Create:Int()
		Local soffx:Int
		Local soffy:Int = DeviceHeight()/2-tilesize
		soffx = DeviceWidth()/2-(3/2*tilesize)

		
		


		
		If DeviceWidth() > DeviceHeight()
			tilesize = DeviceHeight()/gamesize
			Else
			tilesize = DeviceWidth()/gamesize
		Endif
			
		offx = DeviceWidth()/2-(gamesize/2*tilesize)
		
'		threeplayer = New Grid(3,1,tilesize,DeviceWidth()/2-(3/2*tilesize),soffy)
'		fourplayer = New Grid(4,1,tilesize,DeviceWidth()/2-(4/2*tilesize),soffy+tilesize)
'		fiveplayer = New Grid(5,1,tilesize,DeviceWidth()/2-(5/2*tilesize),soffy+2*tilesize)
 





		SetUpdateRate(60) 	
' 
		myboard = New Grid(gamesize,gamesize,tilesize,offx,offy)


		solutions = CreateSolutions(5,20)
'		myboard.AddPiece(1,1,p1)
'		myboard.AddPiece(2,1,p1) 
		currentplayer = p1
		

		Return 0
	End Method
	
	Method Update:Int()
 		If TouchHit(0)

 				myboard.AddPiece(TouchX(0),TouchY(0),currentplayer)
 				If CheckTiles(currentplayer) Print "Match"
				If currentplayer = p1
					currentplayer = p2
					Else
					currentplayer = p1
				Endif
				

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
		
		'For Local n:= Eachin solutions
			
			'n.Render
		
		'Next
 

		Return 0
	End Method
	
		Method CheckTiles:Bool(p:Piece)
		For Local s:= Eachin solutions
			For Local by:Int = 0 Until myboard._sy - s._sy
				For Local bx:Int = 0 Until myboard._sx - s._sx
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
				If match = True Return True
			Next
		Next
		next
		Return False
	End method


End Class

Class Piece 
 
	Field _r:Int  
	Field _g:Int 
	Field _b:Int 

	Method New()
	
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

Class Grid
	Field _sx:Int 
	Field _sy:Int 
	'Field myboxes:Box[]
	Field teamsize:Int = 10
	Field pieces:Piece[]
	Field _tilesize:Int
	Field _offsetx:Int
	Field _offsety:Int
		
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
			
					SetColor(255,255,255)
					DrawRect(x*_tilesize+1+_offsetx,y*_tilesize+1+_offsety,_tilesize-2,_tilesize-2)

				If pieces[I(x,y)]
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
		If myx < 0 Or myx > _sx
			Return Null
		Endif
		If myy < 0 Or myy > _sy
			Return Null
		Endif
		
		Return New Vec2i((x-_offsetx)/_tilesize,(y-_offsety)/_tilesize)
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
	Local checkpiece:= New Piece(40,40,40)

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
