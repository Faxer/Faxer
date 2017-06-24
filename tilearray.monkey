Strict
Import Mojo


Function Main:Int()

	Local theapp:MyApp = New MyApp

	Return 0	
End Function


Class MyApp Extends App

 
	Const tilesize:Int = 32

	Field myboard:Grid  
	
	Method OnCreate:Int()
	
 
		SetUpdateRate(60) 	
' 
		myboard = New Grid(2,3,tilesize)
 
		
		Return 0
	End Method
	
	Method OnUpdate:Int()
 
	
	
		Return 0
	End Method
	
	Method OnRender:Int()
		Cls(255,0,0)
'		mygrid.Render
		myboard.Render
 
		Return 0
	End Method

End Class
 

Class Piece 
 
	Field r:Int  
	Field g:Int 
	Field b:Int 

	Method New()
	
		Self.r = 40'Rnd(0,255)
		Self.g = 40'Rnd(0,255)		
		Self.b = 40'Rnd(0,255)
		
'		Self.x = Rnd(w/4,w/4*3)
'		Self.y = Rnd(h/4,h/4*3)	
		

	
	End method

	Method Draw:Void(x:Float,y:Float,w:int,h:int)
	
		SetColor(r,g,b)
		Print x
	
		DrawRect(x,y,w,h)		


	End Method
	
	Method Update:void()
		'Self.r = Rnd(0,255)
		'Self.g = Rnd(0,255)
		'Self.b = Rnd(0,255)	
	End Method


End Class

Class Grid
	Field _sx:Int 
	Field _sy:Int 
	Const tilesize:Int = 32
	'Field myboxes:Box[]
	Field teamsize:Int = 10
	Field pieces:Piece[]
	Field _tilesize:int
	
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
				Local index:Int = y*_sx + x

				If pieces[index]
					pieces[index].Draw(x*tilesize,y*tilesize,tilesize,tilesize)
				Else
					DrawRect(x*tilesize+1,y*tilesize+1,tilesize-2,tilesize-2)
				Endif

			Next	
			
		Next
		
'		For Local n:Int = 0 Until pieces.Length
'			pieces[n].Create(tilesize)
'		
'		Next
	
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
