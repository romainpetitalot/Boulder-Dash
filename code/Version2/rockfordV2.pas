program Rockfrd;

uses SDL, sdl_image, sdl_ttf, sysutils,menurockford, rockfordUtils;

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


procedure afficherfond(var window, rockford : PSDL_Surface; T : Terrain; position : coordonnees; notMoving : Boolean);
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
	
	if notMoving then
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
		SDl_Delay(17);
		
		coordRF.x := coordRF.x + sens*12;
		afficherfond(window, SurfaceFake, T, coordFake, False);
		SDL_BlitSurface(RF2, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(18);
		
		coordRF.x := coordRF.x + sens*12;
		afficherfond(window, SurfaceFake, T, coordFake, False);
		SDL_BlitSurface(RF3, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(17);
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
		SDl_Delay(12);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfond(window, SurfaceFake, T, coordFake, False);
		SDL_BlitSurface(RF2, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(12);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfond(window, SurfaceFake, T, coordFake, False);
		SDL_BlitSurface(RF3, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(12);
		
		coordRF.y := coordRF.y + sens*8;
		afficherfond(window, SurfaceFake, T, coordFake, False);
		SDL_BlitSurface(RF4, NIL, window,@coordRF);
		SDl_Flip(window);
		SDl_Delay(12);
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


procedure tombePierre(var window, rockford : Psdl_Surface; var T:Terrain; position : coordonnees; nomObjet:string; var nbDiamant : Integer; var fin : Boolean );
var i, j, numeroObj, coordY : Integer;
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
					fin := True;
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
			
			if T[i][j].genre = numeroObj then //Les éboulements sur le côté
			begin
				if (T[i+1][j].genre = 3) or (T[i+1][j].genre = 4) then
				begin
					coordY := i+1;
					while (T[coordY][j].genre = 3)or(T[coordY][j].genre = 4) do //Pour verif que la pierre en dessous est pas en train de tomber
					begin
						coordY := coordY +1;					
					end;
					if T[coordY][j].genre <> 0 then
					begin
						if(T[i+1][j-1].genre=0)and(T[i][j-1].genre=0)and not((position.y=i+1)and(position.x=j-1))and not((position.y=i)and(position.x=j-1))and(T[i-1][j-1].mouvement='')and(T[i][j-1].mouvement='')then
						begin
							T[i][j-1].genre := numeroObj;
							T[i][j].genre := 0;
							afficherfond(window, rockford, T, position, True);
							SDl_delay(20);
						end
						else if (T[i+1][j+1].genre=0)and(T[i][j+1].genre=0)and not((position.y=i+1)and(position.x=j+1))and not((position.y=i)and(position.x=j+1))and(T[i-1][j+1].mouvement='')and(T[i][j+1].mouvement='')then
						begin
							T[i][j+1].genre := numeroObj;
							T[i][j].genre := 0;
							afficherfond(window, rockford, T, position, True);
							SDl_delay(20);
						end; 
					end;
				end;
			end;
		end;
	end;
	afficherfond(window, rockford, T, position, True);
end;


procedure movePapillonAntiClockwise(var window, rockford : Psdl_Surface; var T:Terrain; position : coordonnees;var fin:Boolean );
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
				case T[i][j].orientation of
					'haut' :
					begin
						if (T[i][j+1].genre = 0) and (T[i+1][j+1].genre <> 0) then
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
				if (position.x = j) and (position.y = i) then
					fin := True
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


procedure deplacementRF(var window, rockford : Psdl_Surface; var T:Terrain; var position,positionFin: coordonnees; var coord : TSDL_Rect;
						var fin, u, d, r, l, save : Boolean;var nbDiamant,nbDiamantFin,Chrono,OldChrono, reserveTemps:Integer;counter:Longint);
var event : TSDL_event;
	portActive, Bouger : Boolean;
	oldNbDiamant, Rrgb, Vrgb, Brgb, i : Integer;
	TempsChoixDebut : LongInt;
begin
	SDL_PollEvent(@event);
	portActive := False;
	Bouger := False;
	oldNbDiamant := nbDiamant;
	
	if nbDiamant > nbDiamantFin then
	begin
		T[positionFin.y][positionFin.x].genre := 5;
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
						afficherfond(window, rockford, T, position, True);
						for i:=3 downto 1 do //Décompte avant de rejouer
						begin
							ecrire(window, IntToStr(i), 375, 0, 45, 146, 146, 255);
							SDl_Flip(window);
							Sdl_Delay(999);
							ecrire(window, IntToStr(i), 375, 0, 45, 0, 0, 0);
						end;
						
						if Chrono + (SDL_GetTicks()-TempsChoixDebut)div 1000<=60 then
							reserveTemps := reserveTemps + (SDL_GetTicks()-TempsChoixDebut)div 1000
						else
							reserveTemps := reserveTemps + Chrono + (SDL_GetTicks()-TempsChoixDebut)div 1000 - 60;
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
	if Bouger or (counter mod 5<2) then
	begin
		tombePierre(window, rockford, T, position, 'Pierre', nbDiamant, fin);
		tombePierre(window, rockford, T, position, 'Diamant', nbDiamant, fin);
		if (counter mod 2)<1 then	
			movePapillonAntiClockwise(window, rockford, T, position, fin);
	end;
	
	Rrgb := 0; Vrgb := 0; Brgb :=0;
	ecrire(window, IntToStr(OldChrono), 600, 5, 35, Rrgb, Vrgb, Brgb);
	if Chrono < 10 then
	begin
		Rrgb := 255; Vrgb := 0; Brgb :=0
	end
	else
	begin
		Rrgb := 255; Vrgb := 255; Brgb :=255;
	end;
	ecrire(window, IntToStr(Chrono), 600, 5, 35, Rrgb, Vrgb, Brgb);
	
	Rrgb := 0; Vrgb := 0; Brgb :=0;
	ecrire(window, IntToStr(oldNbDiamant), 290, 5, 35, Rrgb, Vrgb, Brgb);
	if nbDiamant > nbDiamantFin then
	begin
		Rrgb := 255; Vrgb := 228; Brgb :=54
	end
	else
	begin
		Rrgb := 255; Vrgb := 255; Brgb :=255;
	end;
	ecrire(window, IntToStr(nbDiamant), 290, 5, 35, Rrgb, Vrgb, Brgb);
		
	SDL_Flip(window);
	SDL_Delay(15);
end;


procedure initPapillon(var T : Terrain);
var i, j:Integer;
begin
	for i := 1 to 24 do
	begin
		for j := 1 to 20 do
		begin
			if T[i][j].genre = 6 then
			begin
				if T[i][j-1].genre <> 0 then
					T[i][j].orientation := 'bas'
				else if T[i-1][j].genre <> 0 then
					T[i][j].orientation := 'gauche'
				else if T[i+1][j].genre <> 0 then
					T[i][j].orientation := 'droite'
				else
					T[i][j].orientation := 'haut'
			end;
		end;
	end;
end;

procedure chargement (name : string; var T : Terrain;var posRF, posFin : coordonnees;var nbDiamant, nbDiamantFin, reserveTemps : Integer);
var fic	: Text;
	i, j : Integer;
	str: String;
begin
	assign(fic,name + '.txt');
	reset(fic);
	i:=1;
	read(fic, posRF.x);//On commence par lire les données du niveau
	readln(fic, posRF.y);
	read(fic, posFin.x);
	readln(fic, posFin.y);
	read(fic, nbDiamant);
	readln(fic, nbDiamantFin);
	readln(fic, reserveTemps);
	while (not eof(fic)) do
	begin
		readln(fic,str);
		for j := 1 to 24 do
		begin
			T[i][j].genre := StrToInt(str[j]);//On lit la map
			T[i][j].mouvement := '';
		end;
		i:=i+1;	
	end;
	
	close(fic);
	T[posRF.y][posRF.x].genre := 0;//Notre personnage part sur une case vide
	initPapillon(T);//Calcul de la direction dans laquelle les papillons vont devoir partir
end;

procedure SauvegarderNiveau(T : Terrain; posRF, posFin : coordonnees; nbDiamant, nbDiamantFin, reserveTemps : Integer);
var fic	: Text;
	i, j : Integer;
begin
	assign(fic,'ressources/Niveaux v1/save.txt');
	reset(fic);
	rewrite(fic);
	write(fic,IntToStr(posRF.x)+' ');writeln(fic,posRF.y);
	write(fic,IntToStr(posFin.x)+' ');writeln(fic,posFin.y);
	write(fic,IntToStr(nbDiamant)+' ');writeln(fic,nbDiamantFin);
	writeln(fic,reserveTemps);
	for i := 1 to 24 do
	begin
		 for j:= 1 to 24 do
			write(fic,IntToStr(T[i][j].genre));
		writeln(fic,'');
	end;
	close(fic);
end;

var window, rockford, Logo, Logo2 : PSDL_Surface;
	coord, coordFondHaut : TSDL_Rect;
	niv, nbDiamant,nbDiamantFin, Temps, TempsInit, reserveTemps, OldTemps,ch1,ch2 : Integer;
	position,positionFin : coordonnees;
	T : Terrain;
	fin,u, d, r, l,save : Boolean;
	counter : LongInt;
begin
	Logo := IMG_Load('Top1.png');
	Logo2 := IMG_Load('Top2.png');
	menu(fin,ch1,ch2);
	initialise(window, rockford);
	randomize();
	counter := 0;

	niv := 1; //random(10) + 
	
	
	fin := False;
	if ch1 = 1 then
		begin
			if ch2 = 1 then
				chargement('ressources/Niveaux v1/v1-' + IntToStr(niv),T, position, positionFin, nbDiamant, nbDiamantFin, reserveTemps)
			else if ch2 = 2 then
				chargement('ressources/Niveaux v1/v2-' + IntToStr(niv),T, position, positionFin, nbDiamant, nbDiamantFin, reserveTemps)
			else if ch2 = 3 then
				chargement('ressources/Niveaux v1/v3-' + IntToStr(niv),T, position, positionFin, nbDiamant, nbDiamantFin, reserveTemps);
		end
	else
		chargement('ressources/Niveaux v1/save',T, position, positionFin, nbDiamant, nbDiamantFin, reserveTemps); // pouvoir y jouer grâce au menu
	
	coordFondHaut.x := 96;
	coordFondHaut.y := 5;
	coord.x := 32*(position.x-1);
	coord.y := 32*(position.y-1) + 50;

		
	afficherfond(window, rockford, T, position, True);
	SDl_Flip(window);
	SDl_Delay(20);
	
	u := False;	d := False;
	r := False;	l := False;
	
	ecrire(window, IntToStr(nbDiamantFin), 80, 5, 35, 255, 228, 54);
	ecrire(window, IntToStr(ch2)+'-'+IntToStr(niv), 130, 5, 35, 255, 255, 255);
	
	TempsInit := SDL_GetTicks() div 1000;
	repeat
		Temps := reserveTemps - (SDL_GetTicks()div 1000 - TempsInit) ; 
		if Temps < 0 then
			fin := True;
		if counter mod 10 < 5 then
			SDL_BlitSurface(Logo, NIL, window,@coordFondHaut)
		else
			SDL_BlitSurface(Logo2, NIL, window,@coordFondHaut);
		
		deplacementRF(window, rockford, T, position,positionFin, coord, fin, u, d, r, l,save, nbDiamant,nbDiamantFin, Temps, OldTemps, reserveTemps, counter);
		OldTemps := Temps;	
		counter := counter + 1;
	until fin or save;
	if save then
		SauvegarderNiveau(T, position, positionFin, nbDiamant, nbDiamantFin, Temps);
	SDL_FreeSurface(window);
	SDL_Quit();
end.
