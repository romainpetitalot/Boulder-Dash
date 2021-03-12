program Rockfrd;

uses SDL, sdl_image, sysutils;

CONST longueur = 24;
		largueur = 20;

Type coordonnees = record
	x : Integer;
	y : Integer;	
end;

Type block = record
	genre : Integer;
	afficher : Boolean;
end;

Type Terrain = array[1..50,1..50] of block;

procedure initialise( var window, rockford : PSDL_Surface);
begin
	SDL_Init(SDL_INIT_VIDEO + SDL_INIT_AUDIO);
	SDL_putenv('SDL_VIDEO_WINDOW_POS=center');
	window := SDL_SetVideoMode(32*longueur, 32*largueur, 32, SDL_DOUBLEBUF + SDL_HWSURFACE + SDL_NOFRAME);
	
	rockford := IMG_Load('ressources/face.png');
	
	SDL_ShowCursor(SDL_DISABLE);
end;


procedure formationTerre (var T : Terrain);
var i, j : Integer;
	
begin
	randomize;
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin
			if (random(3)<2) then T[i][j].genre := 1
			else if (random(3)<2) then T[i][j].genre := 3;
			
			if (i = 1) or (i = largueur) or (j=1) or (j=longueur) then T[i][j].genre := 2;
			
			//writeln(i,' ',j,' ',T[i][j].genre);
		end;
	end;
	
	T[4][3].genre := 0;
	
end;



procedure afficherfond(var window : PSDL_Surface; T : Terrain);
var fond, terre, bordure, pierre : PSDL_Surface;
	coordfond : TSDL_Rect;
	i, j : Integer;
begin
	fond := IMG_Load('ressources/fond.png');
	terre := IMG_Load('ressources/terre.png');
	bordure := IMG_Load('ressources/bordure.png');
	pierre := IMG_Load('ressources/pierre.png');
	
	coordfond.x := 0;
	coordfond.y := 0;
	
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin
			coordfond.x := (j-1)*32;
			
			case T[i][j].genre of
			
				1 : SDL_BlitSurface(terre, NIL, window,@coordfond);
				
				2 :	SDL_BlitSurface(bordure, NIL, window,@coordfond);				
			
				3 : SDL_BlitSurface(pierre, NIL, window,@coordfond);
				
				0 : SDL_BlitSurface(fond, NIL, window,@coordfond);	
			end;		
		end;
		coordfond.y := (i)*32
	end;
	SDl_Flip(window);
	SDL_FreeSurface(fond);
	SDL_FreeSurface(terre);
	SDL_FreeSurface(bordure);
	SDL_FreeSurface(pierre);
end;

procedure deplacementRockFordHoriz(var window : PSDL_Surface; direction : String; var coordRF : TSDL_Rect; sens : Integer; var pos : Integer; var T : Terrain);
var RF1, RF2, RF3 : PSDL_Surface;
	chemin : String;
	pimage : PChar;
	i : Integer;
begin
	chemin := 'ressources/'+direction+'1.png';
	pimage := StrAlloc(length(chemin)+1);
	strPCopy(pimage, chemin);
	RF1 := IMG_Load(pimage);

	chemin := 'ressources/'+direction+'2.png';
	pimage := StrAlloc(length(chemin)+1);
	strPCopy(pimage, chemin);
	RF2 := IMG_Load(pimage);
	
	chemin := 'ressources/'+direction+'3.png';
	pimage := StrAlloc(length(chemin)+1);
	strPCopy(pimage, chemin);
	RF3 := IMG_Load(pimage);
	
	for i := 1 to 1 do
	begin
		coordRF.x := coordRF.x + sens*8;
		afficherfond(window, T);
		SDL_BlitSurface(RF1, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(20);
		
		coordRF.x := coordRF.x + sens*12;
		afficherfond(window, T);
		SDL_BlitSurface(RF2, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(20);
		
		coordRF.x := coordRF.x + sens*12;
		afficherfond(window, T);
		SDL_BlitSurface(RF3, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(20);
	
	end;
	
	SDL_FreeSurface(RF1);
	SDL_FreeSurface(RF2);
	SDL_FreeSurface(RF3);
	
	pos := pos + sens;
	
end;

procedure deplacementRockFordVert(var window : PSDL_Surface; direction : String; var coordRF : TSDL_Rect; sens : Integer; var pos : Integer; var T : Terrain);
var RF1, RF2, RF3, RF4 : PSDL_Surface;
	chemin : String;
	pimage : PChar;
	i : Integer;
begin
	chemin := 'ressources/'+direction+'1.png';
	pimage := StrAlloc(length(chemin)+1);
	strPCopy(pimage, chemin);
	RF1 := IMG_Load(pimage);

	chemin := 'ressources/'+direction+'2.png';
	pimage := StrAlloc(length(chemin)+1);
	strPCopy(pimage, chemin);
	RF2 := IMG_Load(pimage);
	
	chemin := 'ressources/'+direction+'3.png';
	pimage := StrAlloc(length(chemin)+1);
	strPCopy(pimage, chemin);
	RF3 := IMG_Load(pimage);
	
	chemin := 'ressources/'+direction+'4.png';
	pimage := StrAlloc(length(chemin)+1);
	strPCopy(pimage, chemin);
	RF4 := IMG_Load(pimage);
	
	for i := 1 to 1 do
	begin
		coordRF.y := coordRF.y + sens*8;
		afficherfond(window, T);
		SDL_BlitSurface(RF1, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(15);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfond(window, T);
		SDL_BlitSurface(RF2, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(15);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfond(window, T);
		SDL_BlitSurface(RF3, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(15);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfond(window, T);
		SDL_BlitSurface(RF4, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(15);
	
	end;
	
	SDL_FreeSurface(RF1);
	SDL_FreeSurface(RF2);
	SDL_FreeSurface(RF3);
	SDL_FreeSurface(RF4);
	
	pos := pos + sens;
end;


procedure tombement(var window : PSDL_Surface; i, j : Integer; T : Terrain);
var coordPiR : TSDL_Rect;
	pierre : PSDL_Surface;
	k : Integer;
begin
	pierre := IMG_Load('ressources/pierre.png');
	
	coordPiR.x := 32 * (j-1);
	coordPiR.y := 32 * (i-1);
	
	for k := 1 to 4 do
	begin
		afficherfond(window, T);
		SDL_BlitSurface(pierre, NIL, window,@coordPiR);
		coordPiR.y := coordPiR.y + 8;
		SDl_Flip(window);
		SDl_Delay(10);
	end;
	

	SDL_FreeSurface(pierre);
end;


procedure tombePierre(var window : Psdl_Surface; var T:Terrain; pos : coordonnees; var accel : Boolean);
var i, j : Integer;
begin
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin
			if T[i][j].genre = 3 then
			begin
				if T[i+1][j].genre = 0 then
				begin
					T[i][j].genre := 0;
					tombement(window, i, j, T);
					T[i+1][j].genre := 3;
					
					//afficherfond(window, T);
				end;
			end;		
		end;
	end;
	SDL_Delay(10);
end;

var window, rockford : PSDL_Surface;
	coord : TSDL_Rect;
	fin, accel : Boolean;
	event : TSDL_Event;
	position : coordonnees;
	T : Terrain;
	bloquer : Boolean;
begin
	
	initialise(window, rockford);
	
	position.x := 4;
	position.y := 3;
	
	coord.x := 32*(position.x-1);
	coord.y := 32*(position.y-1);
	
	fin := False;
	
	formationTerre(T);
	afficherfond(window, T);
	SDL_BlitSurface(rockford, NIL, window,@coord);
	SDl_Flip(window);
	SDl_Delay(20);
	
	accel := False;
	
	repeat
		//writeln('x = ',position.x,'  y = ',position.y);
		SDL_PollEvent(@event);
		if event.type_ = SDL_KEYDOWN then
		begin
		
			bloquer := False;
			tombePierre(window, T, position, accel);
			
			case event.key.keysym.sym of 
				SDLK_escape : fin := True;
				SDLK_up : 
				begin
					if T[position.y-1][position.x].genre = 1 then T[position.y-1][position.x].genre := 0; 
					
					if not(T[position.y-1][position.x].genre = 2) and not(T[position.y-1][position.x].genre = 3) then 
						deplacementRockFordVert(window, 'haut', coord, -1, position.y, T);
				end;
				SDLK_down : 
				begin
					if T[position.y+1][position.x].genre = 1 then T[position.y+1][position.x].genre := 0;
				
					if not(T[position.y+1][position.x].genre = 2) and not(T[position.y+1][position.x].genre = 3) then 
						deplacementRockFordVert(window, 'bas', coord, 1, position.y, T);
				end;
				SDLK_right : 
				begin
					if T[position.y][position.x+1].genre = 1 then T[position.y][position.x+1].genre := 0;
					
					if T[position.y][position.x+1].genre = 3 then
					begin
						if T[position.y][position.x+2].genre = 0 then
						begin
							T[position.y][position.x+1].genre := 0;
							T[position.y][position.x+2].genre := 3;
							bloquer := False;
							SDL_Delay(10);
						end
						else bloquer := True					
					
					end;
					
					if not(T[position.y][position.x+1].genre = 2) and not(bloquer) then
					deplacementRockFordhoriz(window, 'droite', coord, 1, position.x, T);
				end;
				SDLK_left : 
				begin
					if T[position.y][position.x-1].genre = 1 then T[position.y][position.x-1].genre := 0;
					
					
					if T[position.y][position.x-1].genre = 3 then
					begin
						if T[position.y][position.x-2].genre = 0 then
						begin
							T[position.y][position.x-1].genre := 0;
							T[position.y][position.x-2].genre := 3;
							bloquer := False;
							SDL_Delay(10);
						end
						else bloquer := True					
					
					end;
					
					if not(T[position.y][position.x-1].genre = 2) and not(bloquer) then
					deplacementRockFordhoriz(window, 'gauche', coord, -1, position.x, T);
				end;
			end;
		end;
		
		writeln('x = ',position.x,'  y = ',position.y);
		
	until fin
end.
