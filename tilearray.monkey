Strict
Import Mojo


Function Main:Int()

	Local theapp:MyApp = New MyApp

	Return 0	
End Function


Class MyApp Extends App
	Field p1:= New Piece(40,40,100)
	Field p2:= New Piece(255,0,100)
	Field currentplayer:Piece  
	Field Shortestside:int

 
	field tilesize:Int 

	Field myboard:Grid  
	
	Method OnCreate:Int()
		Local shortestside:Int
		Local gamesize:Int = 15
		
		If DeviceWidth() > DeviceHeight()
			tilesize = DeviceHeight()/gamesize
			Else
			tilesize = DeviceWidth()/gamesize
		endif
			
			
	
 
		SetUpdateRate(60) 	
' 
		myboard = New Grid(15,15,tilesize)
		
'		myboard.AddPiece(1,1,p1)
'		myboard.AddPiece(2,1,p1) 
		currentplayer = p1
		
		Return 0
	End Method
	
	Method OnUpdate:Int()
 		If TouchHit(0)
 			If myboard.TileCheck(TouchX(0)/tilesize,TouchY(0)/tilesize) = True
 				myboard.AddPiece(TouchX(0)/tilesize,TouchY(0)/tilesize,currentplayer)
				If currentplayer = p1
					currentplayer = p2
					Else
					currentplayer = p1
				Endif
			endif
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


		Return 0
	End Method
	
	Method OnRender:Int()
		Cls(100,150,150)
'		mygrid.Render
		myboard.Render
 
		Return 0
	End Method

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

	Method Draw:Void(x:Float,y:Float,tilesize:int)
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
	
	Method New (sx:Int,sy:Int,tilesize:Int)
		_sx = sx
		_sy = sy
		_tilesize = tilesize
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
					DrawRect(x*_tilesize+1,y*_tilesize+1,_tilesize-2,_tilesize-2)

				If pieces[I(x,y)]
					pieces[I(x,y)].Draw(x*_tilesize,y*_tilesize,_tilesize)
	 
			
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
	
	Method AddPiece:Void (x:Int,y:Int,p:Piece)
		pieces[I(x,y)] = p
		

	End Method
	
	Method TileCheck:Bool(x:Int,y:Int)
		If pieces[I(x,y)]
			Return True 
		Else
			Return False
			endif
	End Method

End Class

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
