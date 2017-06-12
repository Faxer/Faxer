Strict
Import Mojo


Function Main:Int()

	Local theapp:MyApp = New MyApp


	Return 0	
End Function


Class MyApp Extends App

'	Field sx:Int 
'	Field sy:Int 
'	Const tilesize:Int = 32
'
'	Field myboxes:Box[][]
'	Field mygrid:Board = New Board

	Field myboard:Board = New Board
	
	
	
	Method OnCreate:Int()
'		mygrid.Create
		myboard.Create
		
'		sx = DeviceWidth()/tilesize
'		sy = DeviceHeight()/tilesize
'		SetUpdateRate(60) 	
'			Print DeviceWidth()
'	
'		myboxes = New Box[sx][]
'		
'		For Local i:Int = 0 Until myboxes.Length
'			myboxes[i] = New Box[sy]
'			For Local n:Int = 0 Until sy
'				myboxes[i][n] = New Box
'			
'			Next
'		
'		
'		Next
'		
		
		
		Return 0
	End Method
	
	Method OnUpdate:Int()
	
		
'		mygrid.Update

		myboard.Update
'		For Local i:Int = 0 Until sx
'			For Local n:Int = 0 Until sy
'				myboxes[i][n].Update
			
'			Next
		
		
'		Next
	
	
		Return 0
	End Method
	
	Method OnRender:Int()
		Cls(255,0,0)
'		mygrid.Render
		myboard.Render
'		For Local x:Int = 0 Until myboxes.Length
'			For Local y:Int = 0  Until sy
'				myboxes[x][y].Draw(x*tilesize,y*tilesize,tilesize,tilesize)
'
'
'			Next
'			
'		Next
		Return 0
	End Method

End Class












Class Box 

'	Field x:Float 
'	Field y:Float
'	Field w:Float = DeviceWidth()
'	Field h:Float = DeviceHeight()
	Field r:Int  
	Field g:Int 
	Field b:Int 

	Method New()
	
		Self.r = Rnd(0,255)
		Self.g = Rnd(0,255)		
		Self.b = Rnd(0,255)
		
'		Self.x = Rnd(w/4,w/4*3)
'		Self.y = Rnd(h/4,h/4*3)	
		

	
	End method

	Method Draw:Void(x:Float,y:Float,w:int,h:int)
	
		SetColor(r,g,b)
		Print x
	
		DrawRect(x,y,w,h)		


	End Method
	
	Method Update:void()
		Self.r = Rnd(0,255)
		Self.g = Rnd(0,255)
		Self.b = Rnd(0,255)	
	End Method


End Class

Class Board


	Field sx:Int 
	Field sy:Int 
	Const tilesize:Int = 32
	Field myboxes:Box[]
	Field teamsize:Int = 10
	Field pieces:Piece[10]
	
	Method Create:Void()
		Print "It works"
		
		sx = DeviceWidth()/tilesize
		sy = DeviceHeight()/tilesize
		SetUpdateRate(60) 	
			Print DeviceWidth()
	
		myboxes = New Box[sx*sy]
		
		For Local i:Int = 0 Until myboxes.Length
			myboxes[i] = New Box
			
		
		
		Next
		
				For Local i:Int = 0 Until teamsize
			pieces[i] = New Piece
		
		
		
		
		Next
	
	
		
		For Local i:Int = 0 Until teamsize
			
				pieces[i].x = (i+1)-0.5
'				Pieces[i].y *= tilesize

			
		
		Next 
		

		

	
	End Method
	
	Method Update:Void ()
	
		

		For Local i:Int = 0 Until sx*sy
			
				myboxes[i].Update
			
		
		
		Next
	
	

	
	End Method
	
	
	Method Render:Void ()
	
		For Local y:Int = 0 Until sy
			For Local x:Int = 0  Until sx
				Local index:Int = y*sy + x
				
				myboxes[index].Draw(x*tilesize,y*tilesize,tilesize,tilesize)


			Next	
			
		Next
		
		For Local n:Int = 0 Until pieces.Length
			pieces[n].Create(tilesize)
		
		
		
		
		
		Next
	
	End Method
	



End Class

Class Piece
	Field x:Float 
	Field y:float = 0.5
	Field color:Int

	Method Create:Void (tilesize:Int)
	
		
	'	SetColor(255,255,255)
				
		'DrawCircle(x*tilesize,y*tilesize,tilesize)
		DrawCircle(x*tilesize,y*tilesize,tilesize/2)
		
		
		
	End Method


End Class

