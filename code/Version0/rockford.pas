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
	afficher, mouvement, Pierre1 : Boolean;
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

procedure formationTerre (var T : Terrain); //On charge la map aléatoirement pour l'instant
var i, j : Integer;	
begin
	randomize;
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin
			if (random(3)<2) then T[i][j].genre := 1
			else if (random(3)<2) then 
			begin
				T[i][j].genre := 3;
				T[i][j].mouvement := False;
				T[i][j].Pierre1 := False;
			end;
			if (i = 1) or (i = largueur) or (j=1) or (j=longueur) then T[i][j].genre := 2;	
		end;
	end;
	T[3][4].genre := 0;
end;

procedure afficherfondDeplacement(var window : PSDL_Surface;var T : Terrain);
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
	
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin
			coordfond.x := (j-1)*32;
						
			if T[i][j].Pierre1 then
			begin
				coordfond.y := coordfond.y + 16;
				SDL_BlitSurface(pierre, NIL, window,@coordfond);
				coordfond.y := coordfond.y - 16;
				//T[i][j].Pierre1 := False;
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

procedure afficherfond(var window, rockford : PSDL_Surface; T : Terrain; position : coordonnees);
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
	
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin
			coordfond.x := (j-1)*32;
						
			if T[i][j].Pierre1 then
			begin
				coordfond.y := coordfond.y + 16;
				SDL_BlitSurface(pierre, NIL, window,@coordfond);
				coordfond.y := coordfond.y - 16;
				//T[i][j].Pierre1 := False;
			end;
		end;
		coordfond.y := (i)*32
	end;
	
	coordfond.x := 32*(position.x-1);
	coordfond.y := 32*(position.y-1);
	
	SDL_BlitSurface(rockford, NIL, window,@coordfond);
	
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
		afficherfondDeplacement(window, T);
		SDL_BlitSurface(RF1, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(20);
		
		coordRF.x := coordRF.x + sens*12;
		afficherfondDeplacement(window, T);
		SDL_BlitSurface(RF2, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(20);
		
		coordRF.x := coordRF.x + sens*12;
		afficherfondDeplacement(window, T);
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
		afficherfondDeplacement(window, T);
		SDL_BlitSurface(RF1, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(15);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfondDeplacement(window, T);
		SDL_BlitSurface(RF2, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(15);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfondDeplacement(window, T);
		SDL_BlitSurface(RF3, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(15);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfondDeplacement(window, T);
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


procedure tombePierre(var window, rockford : Psdl_Surface; var T:Terrain; pos : coordonnees; position : coordonnees);
var i, j : Integer;
	pierre : PSDL_Surface;
begin
	pierre := IMG_Load('ressources/pierre.png');
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin
			if T[i][j].mouvement then
			begin
				T[i+1][j].genre := 3;
				T[i][j].Pierre1 := False;
				afficherfond(window, rockford, T, position);
				T[i][j].mouvement := false;
				if (position.y = i+2) and (position.x = j) then 
					writeln('dead');
			end;
			if T[i][j].genre = 3 then
			begin
				if (T[i+1][j].genre = 0) and not((position.y = i+1) and (position.x = j)) then
				begin
					T[i][j].genre := 0;
					T[i][j].mouvement := True;
					T[i][j].Pierre1 := True;
					afficherfond(window, rockford, T, position);
					SDL_Flip(window);
				end;
			end;
					
		end;
	end;
	SDL_FreeSurface(pierre);
end;


procedure deplacementRF(var window, rockford : Psdl_Surface; var T:Terrain; var position : coordonnees; var coord : TSDL_Rect; var fin, u, d, r, l : Boolean);
var event : TSDL_event;
	bloquer : Boolean;
begin
	SDL_PollEvent(@event);
	
	bloquer := False;
	
	case event.type_ of
		SDL_KEYDOWN : 
		
			case event.key.keysym.sym of 
				SDLK_escape : fin := True;
				SDLK_UP : u := True;
				SDLK_DOWN : d := True;
				SDLK_right : r := True;
				SDLK_left : l := True;
		end;

		SDL_KEYUP : 
		
			case event.key.keysym.sym of 
				SDLK_UP : u := False;
				SDLK_DOWN : d := False;
				SDLK_right : r := False;
				SDLK_left : l := False;
		end;
	end;
	
	
	if u then 
	begin
		
		if T[position.y-1][position.x].genre = 1 then T[position.y-1][position.x].genre := 0; 
		
		if not(T[position.y-1][position.x].genre = 2) and not(T[position.y-1][position.x].genre = 3) then 
			deplacementRockFordVert(window, 'haut', coord, -1, position.y, T);
	end;
	
	if d then 
	begin
		if T[position.y+1][position.x].genre = 1 then T[position.y+1][position.x].genre := 0;
	
		if not(T[position.y+1][position.x].genre = 2) and not(T[position.y+1][position.x].genre = 3) then 
			deplacementRockFordVert(window, 'bas', coord, 1, position.y, T);
	end;
		
	if r then 
	begin
		if T[position.y][position.x+1].genre = 1 then T[position.y][position.x+1].genre := 0;
		
		if T[position.y][position.x+1].genre = 3 then
		begin
			if T[position.y][position.x+2].genre = 0 then
			begin
				SDL_Delay(50);
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
	
	if l then
	begin
		if T[position.y][position.x-1].genre = 1 then T[position.y][position.x-1].genre := 0;		
		
		if T[position.y][position.x-1].genre = 3 then
		begin
			if T[position.y][position.x-2].genre = 0 then
			begin
				SDL_Delay(50);
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
	
	tombePierre(window, rockford, T, position, position);
	SDL_Delay(20);
end;

procedure chargement (name : string; var T : Terrain);
var fic	: Text;
	i, j : Integer;
	str: String;
begin
	assign(fic,name + '.txt');
	reset(fic);
	j:=1;
	while (not eof(fic)) do
	begin
		readln(fic,str);
		for i := 1 to 50 do
		begin
			if (str[i] = '0') then
				T[i][j].genre := 0
			else if (str[i] = '1') then
				T[i][j].genre := 1
			else if (str[i] = '2') then
				T[i][j].genre := 2
			else if (str[i] = '3') then
				T[i][j].genre := 3;
			T[i][j].afficher := True;
		end;
			j:=j+1;	
	end;
	close(fic);
end;

var window, rockford : PSDL_Surface;
	coord : TSDL_Rect;
	fin : Boolean;
	position : coordonnees;
	T : Terrain;
	u, d, r, l : Boolean;
begin
	initialise(window, rockford);
	
	position.x := 4;
	position.y := 3;
	
	coord.x := 32*(position.x-1);
	coord.y := 32*(position.y-1);
	
	fin := False;
	
	formationTerre(T);
	afficherfond(window, rockford, T, position);
	SDL_BlitSurface(rockford, NIL, window,@coord);
	SDl_Flip(window);
	SDl_Delay(20);
	
	u := False;	d := False;
	r := False;	l := False;
	
	repeat
		deplacementRF(window, rockford, T, position, coord, fin, u, d, r, l);
	until fin
end.
