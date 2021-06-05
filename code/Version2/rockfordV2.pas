program Rockfrd;

uses SDL, sdl_image, sdl_ttf, sysutils,menurockford, rockfordUtils;

CONST longueur = 24;
		largueur = 20;


procedure initialise( var window, rockford : PSDL_Surface);
begin
	SDL_Init(SDL_INIT_VIDEO + SDL_INIT_AUDIO);
	SDL_putenv('SDL_VIDEO_WINDOW_POS=center');
	window := SDL_SetVideoMode(32*longueur, 32*largueur+50, 32, SDL_DOUBLEBUF + SDL_HWSURFACE + SDL_NOFRAME);
	
	rockford := IMG_Load('ressources/face.png');
	
	SDL_ShowCursor(SDL_DISABLE);
end;

procedure ecrire(var window : PSDL_Surface; txt : String; x, y, taille, R, V, B : Integer);
var police : pTTF_Font;
	couleur : PSDL_Color;
	texte : PSDL_Surface;
	ptxt: pChar;
	position : TSDL_Rect;
begin
	if TTF_INIT=-1 then HALT;
	
	police := TTF_OPENFONT('ressources/RWC.TTF',taille); //Police RWC
	new(couleur);
	couleur^.r:=R; couleur^.g:=V;    couleur^.b:=B; //Couleur qu'on prend en entrée

	ptxt := StrAlloc(length(txt) + 1); 
	StrPCopy(ptxt, txt);
	texte := TTF_RenderText_Solid(police, ptxt, couleur^);
	position.x := x; position.y := y;	
	strDispose(ptxt);
	
	SDL_BlitSurface(texte, NIL, window, @position);

	DISPOSE(couleur);
	TTF_CloseFont(police);
    TTF_Quit();
    SDL_FreeSurface(texte);
end;


procedure afficherfond(var window, rockford : PSDL_Surface; T : Terrain; position : coordonnees; enDeplacement : Boolean);
var fond, terre, bordure, pierre, diamant, port, spider : PSDL_Surface;
	coordfond : TSDL_Rect;
	i, j : Integer;
begin
	fond := IMG_Load('ressources/fond.png');
	terre := IMG_Load('ressources/terre.png');
	bordure := IMG_Load('ressources/bordure.png');
	pierre := IMG_Load('ressources/pierre.png');
	diamant := IMG_Load('ressources/Diamond1.png');
	port := IMG_Load('ressources/Port1.png');
	spider := IMG_Load('ressources/Spider2.png');

	coordfond.x := 0;
	coordfond.y := 50;
	
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin
			coordfond.x := (j-1)*32;
			
			case T[i][j].genre of
				1 : SDL_BlitSurface(terre, NIL, window,@coordfond);
				
				2 :	SDL_BlitSurface(bordure, NIL, window,@coordfond);				
			
				3 : SDL_BlitSurface(pierre, NIL, window,@coordfond);
				
				4 : SDL_BlitSurface(diamant, NIL, window,@coordfond);
				
				5 : SDL_BlitSurface(port, NIL, window,@coordfond);
				
				6 : SDL_BlitSurface(spider, NIL, window,@coordfond);
								
				0 : SDL_BlitSurface(fond, NIL, window,@coordfond);	
			end;	
		end;
		coordfond.y := coordfond.y + 32
	end;
	
	coordfond.y := 50;
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin
			coordfond.x := (j-1)*32;
			
			if T[i][j].mouvement = 'Pierre' then
			begin
				coordfond.y := coordfond.y + 16;
				
				SDL_BlitSurface(pierre, NIL, window,@coordfond);
				coordfond.y := coordfond.y - 16;
			end;
						
			if T[i][j].mouvement = 'Diamant' then
			begin
				coordfond.y := coordfond.y + 16;
				
				SDL_BlitSurface(diamant, NIL, window,@coordfond);
				coordfond.y := coordfond.y - 16;
			end;
		end;
		coordfond.y := coordfond.y + 32
	end;
	
	if enDeplacement then
	begin
		coordfond.x := 32*(position.x-1);
		coordfond.y := 32*(position.y-1) + 50;
		
		SDL_BlitSurface(rockford, NIL, window,@coordfond);
	end;
	SDl_Flip(window);
	SDL_FreeSurface(fond);
	SDL_FreeSurface(terre);
	SDL_FreeSurface(bordure);
	SDL_FreeSurface(diamant);	
	SDL_FreeSurface(port);	
	SDL_FreeSurface(pierre);
	SDL_FreeSurface(spider);
end;

procedure deplacementRockFordHoriz(var window:PSDL_Surface;direction:String;var coordRF:TSDL_Rect;sens:Integer;var pos : Integer;var T : Terrain;var Bouger:Boolean);
var RF1, RF2, RF3, SurfaceFake : PSDL_Surface;
	chemin : String;
	pimage : PChar;
	i : Integer;
	coordFake : coordonnees;
begin
	Bouger := True;
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
		afficherfond(window, SurfaceFake, T, coordFake, False);
		SDL_BlitSurface(RF1, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(20);
		
		coordRF.x := coordRF.x + sens*12;
		afficherfond(window, SurfaceFake, T, coordFake, False);
		SDL_BlitSurface(RF2, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(20);
		
		coordRF.x := coordRF.x + sens*12;
		afficherfond(window, SurfaceFake, T, coordFake, False);
		SDL_BlitSurface(RF3, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(20);
	end;
	
	SDL_FreeSurface(RF1);
	SDL_FreeSurface(RF2);
	SDL_FreeSurface(RF3);
	
	pos := pos + sens;
end;

procedure deplacementRockFordVert(var window:PSDL_Surface;direction:String;var coordRF : TSDL_Rect;sens : Integer;var pos : Integer;var T:Terrain;var Bouger:Boolean);
var RF1, RF2, RF3, RF4, SurfaceFake : PSDL_Surface;
	chemin : String;
	pimage : PChar;
	i : Integer;
	coordFake : coordonnees;
begin
	Bouger := True;
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
		afficherfond(window, SurfaceFake, T, coordFake, False);
		SDL_BlitSurface(RF1, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(15);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfond(window, SurfaceFake, T, coordFake, False);
		SDL_BlitSurface(RF2, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(15);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfond(window, SurfaceFake, T, coordFake, False);
		SDL_BlitSurface(RF3, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(15);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfond(window, SurfaceFake, T, coordFake, False);
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

procedure mortPapillon(var T:Terrain; posX, posY : Integer; var nbDiamant : Integer; positionRF : coordonnees);

begin
	if T[posY][posX-1].genre <> 2 then
	begin
		if (posX-1 = positionRF.x) and (posY = positionRF.y) then
		begin
			nbDiamant := nbDiamant +1;
			T[posY][posX-1].genre := 0;
		end
		else
			T[posY][posX-1].genre := 4;
	end;
	if T[posY][posX].genre <> 2 then
	begin
		if (posX = positionRF.x) and (posY = positionRF.y) then
		begin
			nbDiamant := nbDiamant +1;
			T[posY][posX].genre := 0;
		end
		else
			T[posY][posX].genre := 4;
	end;
	if T[posY][posX+1].genre <> 2 then
	begin
		if (posX+1 = positionRF.x) and (posY = positionRF.y) then
		begin
			nbDiamant := nbDiamant +1;
			T[posY][posX+1].genre := 0;
		end
		else
			T[posY][posX+1].genre := 4;
	end;
end;


procedure tombePierre(var window, rockford : Psdl_Surface; var T:Terrain; position : coordonnees; nomObjet:string; var nbDiamant : Integer );
var i, j, numeroObj : Integer;
begin
	if nomObjet = 'Pierre' then
		numeroObj := 3
	else if nomObjet = 'Diamant' then
		numeroObj := 4;
	
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin
			if T[i][j].mouvement = nomObjet then
			begin
				T[i+1][j].genre := numeroObj;
				T[i][j].mouvement := '';
				afficherfond(window, rockford, T, position, True);
				if (position.y = i+2) and (position.x = j) then 
					writeln('dead');
				if T[i+2][j].genre = 6 then
				begin
					mortPapillon(T, j,i+1, nbDiamant, position);
					
					mortPapillon(T, j,i+2, nbDiamant, position);
					
					mortPapillon(T, j,i+3, nbDiamant, position);
				end;
			end;
			if T[i][j].genre = numeroObj then
			begin
				if (T[i+1][j].genre = 0) and not((position.y = i+1) and (position.x = j)) then
				begin
					T[i][j].genre := 0;
					T[i][j].mouvement := nomObjet;
					afficherfond(window, rockford, T, position, True);
					SDL_Flip(window);
				end
				else if (T[i+1][j].genre = 6)then
				begin
					mortPapillon(T, j,i, nbDiamant, position);
					
					mortPapillon(T, j,i+1, nbDiamant, position);
					
					mortPapillon(T, j,i+2, nbDiamant, position);
				end;
			end;					
		end;
	end;
end;


procedure moveSpiderAntiClockwise(var window, rockford : Psdl_Surface; var T:Terrain; position : coordonnees );
var i, j : Integer;
begin
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin
			T[i][j].Used := False;
		end;
	end;
	
	for i := 1 to largueur do
	begin
		for j := 1 to longueur do
		begin			
			if (T[i][j].genre = 6) and not(T[i][j].Used) then
			begin
				writeln(T[i][j].orientation);
				case T[i][j].orientation of
					'haut' :
					begin
						if T[i][j+1].genre = 0 then
						begin
							T[i][j].genre := 0;
							T[i][j+1].genre := 6;
							T[i][j+1].orientation := 'droite';
							T[i][j+1].Used := True;	//Pour ne pas refaire bouger le même car on retombera dessus dans la boucle for						
						end
						else if T[i-1][j].genre = 0 then
						begin
							T[i][j].genre := 0;
							T[i-1][j].genre := 6;
							T[i-1][j].orientation := 'haut';				
						end
						else
							T[i][j].orientation := 'gauche'
					end;					
					'gauche' :
					begin
						if T[i-1][j].genre = 0 then
						begin
							T[i][j].genre := 0;
							T[i-1][j].genre := 6;
							T[i-1][j].orientation := 'haut';				
						end
						else if T[i][j-1].genre = 0 then
						begin
							T[i][j].genre := 0;
							T[i][j-1].genre := 6;
							T[i][j-1].orientation := 'gauche';
						end
						else
							T[i][j].orientation := 'bas'					
					end;					
					'bas' :
					begin
						if T[i][j-1].genre = 0 then
						begin
							T[i][j].genre := 0;
							T[i][j-1].genre := 6;
							T[i][j-1].orientation := 'gauche';
						end
						else if T[i+1][j].genre = 0 then
						begin
							T[i][j].genre := 0;
							T[i+1][j].genre := 6;
							T[i+1][j].orientation := 'bas';
							T[i+1][j].Used := True;	
						end
						else
							T[i][j].orientation := 'droite'
					end;
					'droite' :
					begin
						if T[i+1][j].genre = 0 then
						begin
							T[i][j].genre := 0;
							T[i+1][j].genre := 6;
							T[i+1][j].orientation := 'bas';
							T[i+1][j].Used := True;							
						end
						else if T[i][j+1].genre = 0 then
						begin
							T[i][j].genre := 0;
							T[i][j+1].genre := 6;
							T[i][j+1].orientation := 'droite';
							T[i][j+1].Used := True;							
						end
						else
							T[i][j].orientation := 'haut'
					end;
				end;	
				afficherfond(window, rockford, T, position, True);
				SDL_Flip(window);	
			end;
		end;
	end;
end;


procedure gestionDeplacement(var window : Psdl_Surface; var T:Terrain;u, d, r, l : Boolean;var Bouger :Boolean; var position : coordonnees; var coord : TSDL_Rect; var nbDiamant:Integer);
var bloquer : Boolean;
begin
	bloquer := False;
	if u then 
	begin
		if T[position.y-1][position.x].genre = 1 then T[position.y-1][position.x].genre := 0; 
		if T[position.y-1][position.x].genre = 4 then
		begin
			T[position.y-1][position.x].genre := 0; 
			nbDiamant := nbDiamant + 1
		end;
		
		if not(T[position.y-1][position.x].genre = 2) and not(T[position.y-1][position.x].genre = 3) then 
			deplacementRockFordVert(window, 'haut', coord, -1, position.y, T, Bouger);
	end;
	
	if d then 
	begin
		if T[position.y+1][position.x].genre = 1 then T[position.y+1][position.x].genre := 0;
		if T[position.y+1][position.x].genre = 4 then
		begin
			T[position.y+1][position.x].genre := 0; 
			nbDiamant := nbDiamant + 1
		end;
		
		if not(T[position.y+1][position.x].genre = 2) and not(T[position.y+1][position.x].genre = 3) then 
			deplacementRockFordVert(window, 'bas', coord, 1, position.y, T, Bouger);
	end;
		
	if r then
	begin
		if T[position.y][position.x+1].genre = 1 then T[position.y][position.x+1].genre := 0;
		if T[position.y][position.x+1].genre = 4 then
		begin
			T[position.y][position.x+1].genre := 0; 
			nbDiamant := nbDiamant + 1
		end;
		
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
			deplacementRockFordhoriz(window, 'droite', coord, 1, position.x, T, Bouger);
	end;
	
	if l then
	begin
		if T[position.y][position.x-1].genre = 1 then T[position.y][position.x-1].genre := 0;		
		if T[position.y][position.x-1].genre = 4 then
		begin
			T[position.y][position.x-1].genre := 0; 
			nbDiamant := nbDiamant + 1
		end;
		
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
			deplacementRockFordhoriz(window, 'gauche', coord, -1, position.x, T, Bouger);
	end;
end;


procedure deplacementRF(var window, rockford : Psdl_Surface; var T:Terrain; var position : coordonnees; var coord : TSDL_Rect;var fin, u, d, r, l, save : Boolean;var nbDiamant, Chrono, OldChrono, reserveTemps:Integer);
var event : TSDL_event;
	portActive, Bouger : Boolean;
	oldNbDiamant, Rrgb, Vrgb, Brgb : Integer;
	TempsChoixDebut : LongInt;
begin
	SDL_PollEvent(@event);
	portActive := False;
	Bouger := False;
	oldNbDiamant := nbDiamant;
	
	if nbDiamant > 1 then
	begin
		T[19][19].genre := 5;
		portActive := True
	end;
	
	case event.type_ of
		SDL_KEYDOWN : 
			case event.key.keysym.sym of 
				SDLK_escape : 
				begin
					TempsChoixDebut := SDL_GetTicks();
					choixFin(window, fin, save, T);
					if not(save) and not(fin) then
					begin
						if Chrono + (SDL_GetTicks()-TempsChoixDebut)div 1000<=60 then
							reserveTemps := reserveTemps + (SDL_GetTicks()-TempsChoixDebut)div 1000
						else
							reserveTemps := reserveTemps + Chrono + (SDL_GetTicks()-TempsChoixDebut)div 1000 - 60;
						afficherfond(window, rockford, T, position, True);
					end;
				end;
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

	gestionDeplacement(window, T, u, d, r, l, Bouger, position, coord, nbDiamant);

	if (position.x = 19) and (position.y = 19) and portActive then
		fin := True;
	if Bouger or (random(5)<2) then
	begin
		tombePierre(window, rockford, T, position, 'Pierre', nbDiamant);
		tombePierre(window, rockford, T, position, 'Diamant', nbDiamant);
		if random(7)<1 then	
			moveSpiderAntiClockwise(window, rockford, T, position);
	end;
	
	Rrgb := 0; Vrgb := 0; Brgb :=0;
	ecrire(window, IntToStr(OldChrono), 100, 5, 35, Rrgb, Vrgb, Brgb);
	if Chrono < 10 then
	begin
		Rrgb := 255; Vrgb := 0; Brgb :=0
	end
	else
	begin
		Rrgb := 255; Vrgb := 255; Brgb :=255;
	end;
	ecrire(window, IntToStr(Chrono), 100, 5, 35, Rrgb, Vrgb, Brgb);
	
	Rrgb := 0; Vrgb := 0; Brgb :=0;
	ecrire(window, IntToStr(oldNbDiamant), 200, 5, 35, Rrgb, Vrgb, Brgb);
	if nbDiamant > 1 then
	begin
		Rrgb := 255; Vrgb := 228; Brgb :=54
	end
	else
	begin
		Rrgb := 255; Vrgb := 255; Brgb :=255;
	end;
	ecrire(window, IntToStr(nbDiamant), 200, 5, 35, Rrgb, Vrgb, Brgb);
		
	SDL_Flip(window);
	SDL_Delay(20);
end;

procedure chargement (name : string; var T : Terrain);
var fic	: Text;
	i, j : Integer;
	str: String;
begin
	assign(fic,name + '.txt');
	reset(fic);
	i:=1;
	while (not eof(fic)) do
	begin
		readln(fic,str);
		for j := 1 to 24 do
		begin
			case str[j] of
				'0':T[i][j].genre := 0;
				'1':T[i][j].genre := 1;
				'2':T[i][j].genre := 2;
				'3':T[i][j].genre := 3;
				'4':T[i][j].genre := 4;
				'5':T[i][j].genre := 5;
				'6':
				begin
					T[i][j].genre := 6;
					T[i][j].orientation := 'bas';
				end;
			end;
			
			T[i][j].mouvement := '';
		end;
			i:=i+1;	
	end;
	close(fic);
end;

procedure SauvegarderNiveau(var T : Terrain);
var fic	: Text;
	i, j : Integer;
begin
	assign(fic,'ressources/Niveaux v1/save.txt');
	reset(fic);
	rewrite(fic);
	j:=1;
	for i := 1 to 24 do
	begin
		 for j:= 1 to 24 do
			case T[i][j].genre of
				0:write(fic,'0');
				1:write(fic,'1');
				2:write(fic,'2');
				3:write(fic,'3');
				4:write(fic,'4');
				5:write(fic,'5');
				6:write(fic,'6');
			end;
			
			writeln(fic,'');
	end;
	close(fic);
end;

var window, rockford : PSDL_Surface;
	coord : TSDL_Rect;
	niv, nbDiamant, Temps, TempsInit, reserveTemps, OldTemps,ch1,ch2 : Integer;
	position : coordonnees;
	T : Terrain;
	fin,u, d, r, l,save : Boolean;
begin
	menu(fin,ch1,ch2);
	initialise(window, rockford);
	randomize();
	position.x := 4;
	position.y := 3;
	niv := 1; //random(10) + 
	coord.x := 32*(position.x-1);
	coord.y := 32*(position.y-1) + 50;
	
	fin := False;
	if ch1 = 1 then
		begin
			if ch2 = 1 then
				chargement('ressources/Niveaux v1/v1-' + IntToStr(niv),T)
			else if ch2 = 2 then
				chargement('ressources/Niveaux v1/v2-' + IntToStr(niv),T)
			else if ch2 = 3 then
				chargement('ressources/Niveaux v1/v3-' + IntToStr(niv),T);
		end
	else
		chargement('ressources/Niveaux v1/save',T); // pouvoir y jouer grâce au menu
	afficherfond(window, rockford, T, position, True);
	SDL_BlitSurface(rockford, NIL, window,@coord);
	SDl_Flip(window);
	SDl_Delay(20);
	
	u := False;	d := False;
	r := False;	l := False;
	nbDiamant := 0;
	
	reserveTemps := 60;
	TempsInit := SDL_GetTicks() div 1000;
	repeat
		Temps := reserveTemps - (SDL_GetTicks()div 1000 - TempsInit) ;
		deplacementRF(window, rockford, T, position, coord, fin, u, d, r, l,save, nbDiamant, Temps, OldTemps, reserveTemps);
		OldTemps := Temps;	
	until fin or save;
	if save then
		SauvegarderNiveau(T);
	SDL_FreeSurface(window);
	SDL_Quit();
end.
