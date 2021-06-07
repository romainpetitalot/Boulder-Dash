unit menurockford;

interface

uses SDL, sdl_image, sdl_mixer,sdl_ttf, sysutils, rockfordUtils;

procedure menu(var fin : Boolean;var ch1,ch2 : Integer);

procedure choixFin(var window : PSDL_Surface; var fin, save : Boolean; T : Terrain);

implementation

procedure initialise( var window, fond, fond2 : PSDL_Surface);
begin
	SDL_Init(SDL_INIT_VIDEO + SDL_INIT_AUDIO);
	SDL_putenv('SDL_VIDEO_WINDOW_POS=center');
	window := SDL_SetVideoMode(32*longueur, 32*largueur, 32, SDL_DOUBLEBUF + SDL_HWSURFACE + SDL_NOFRAME);
	
	fond := IMG_Load('ressources/fond1.png');
	fond2 := IMG_Load('ressources/fond2.png');
end;


procedure termine ( var window , fond, fond2 : PSDL_SURFACE );
begin
	{ vider la memoire correspondant a l ’ image et a la fenetre }
	SDL_FreeSurface ( fond );
	SDL_FreeSurface ( fond2 );
	SDL_FreeSurface ( window );
	{ decharger la bibliotheque }
	SDL_Quit ();
end;

procedure affiche ( var window , menu : PSDL_SURFACE );
var destination_rect : TSDL_RECT ;
begin
	{ Choix de la position et taille de l ’ element a afficher }
	destination_rect.x := 0  ;
	destination_rect.y := 0  ;
	destination_rect.w := 32*longueur ;
	destination_rect.h := 32*largueur ;
	{ Coller l ’ element dans la fenetre window avec les caracteristiques destination_rect }
	SDL_BlitSurface ( menu , NIL , window , @destination_rect );
	{ Afficher la nouvelle image }
	SDL_Flip ( window )
end;

procedure affichecurseur (var window : PSDL_SURFACE; position : coordMenu);
var destination_rect : TSDL_RECT ;
	curseur : PSDL_SURFACE;
begin
	curseur:= IMG_Load('ressources/face.png');
	{ Choix de la position et taille de l ’ element a afficher }
	destination_rect.x :=position.x;
	destination_rect.y :=position.y;
	destination_rect.w := 32;
	destination_rect.h := 32;
	{ Coller l ’ element  dans la fenetre window avec les caracteristiques destination_rect}
	SDL_BlitSurface ( curseur , NIL , window , @destination_rect );
	{ Afficher la nouvelle image }
	SDL_Flip ( window );
	SDL_FreeSurface( curseur );
end;



procedure processKey ( key : TSDL_KeyboardEvent ; var bouge : coordMenu; var window,menu : PSDL_Surface; var fin : Boolean; var choix : Integer );

begin
	case key.keysym.sym of
		SDLK_DOWN : begin 
						bouge.x:=bouge.x;
						bouge.choix:= (bouge.choix+1) mod 3;
						bouge.y:=170+MVT*bouge.choix;
						affiche(window,menu);
						affichecurseur(window,bouge);
					end;
		SDLK_UP : begin 
						bouge.x:=bouge.x;
						bouge.choix:=(bouge.choix-1+3) mod 3; //Pour qu'on puisse retourner sur l'option du haut avec la flèche du bas quand on est en bas
						bouge.y:=170+MVT*bouge.choix;
						affiche(window,menu);
						affichecurseur(window,bouge);
					end;
		SDLK_RETURN : begin
						fin := True;
						choix := bouge.choix + 1;
					end;
	end;
end;
						


procedure son ( var sound : pMIX_MUSIC);
begin
	if MIX_OpenAudio ( MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS,AUDIO_CHUNKSIZE ) <0 then HALT ;
	sound := MIX_LOADMUS ( 'ressources/test.ogg ');
	if sound = nil then writeln('erreur');
	MIX_VolumeMusic ( MIX_MAX_VOLUME );
	if Mix_PlayMusic( sound, 0 ) < 0 then HALT;
end;

procedure termine_musique ( var sound : pMIX_MUSIC );
begin
	MIX_FREEMUSIC ( sound );
	Mix_CloseAudio ();
end;

procedure menu(var fin : Boolean;var ch1,ch2 : Integer);
var window, fond,fond2: PSDL_Surface;
	event,event2 : TSDL_Event;
	sound : pMIX_MUSIC;
	button: coordMenu;
begin
	initialise(window, fond, fond2);
	fin := False ;
	son(sound);
	affiche ( window,fond );
	button.x:=150;
	button.y:=170;
	affichecurseur( window,button);
	button.choix:=0;
	while not fin do
	begin
		SDL_DELAY(70);
		SDL_PollEvent (@event);
		if event.type_ = SDL_KEYDOWN then
			processKey ( event.key , button,window,fond,fin,ch1);
	end;
	if ch1 = 1 then
	begin
		fin := False;
		button.x:=150;
		button.y:=170;
		affiche ( window,fond2 );
		affichecurseur( window,button);
		while not fin do
			begin
				fin := False;
				SDL_DELAY(70);
				SDL_PollEvent(@event2);
					if event2.type_ = SDL_KEYDOWN then
				processKey ( event2.key , button,window,fond2,fin,ch2);
			end;
	end
	else if ch1 = 3 then
		HALT;
	termine_musique(sound);
	termine(window, fond, fond2);
end;

procedure affichageFondFin(var window : PSDL_Surface; T:Terrain);
var coordfond : TSDL_Rect;
	i : Integer;
	fond, terre, bordure, pierre, diamant, port, spider : PSDL_Surface;
begin
	fond := IMG_Load('ressources/fond.png');
	terre := IMG_Load('ressources/terre.png');
	bordure := IMG_Load('ressources/bordure.png');
	pierre := IMG_Load('ressources/pierre.png');
	diamant := IMG_Load('ressources/Diamond1.png');
	port := IMG_Load('ressources/Port1.png');
	spider := IMG_Load('ressources/Spider2.png');
	coordfond.x := 5*32;
	for i:= 0 to 2 do
	begin
		coordfond.y := 50+4*32+128*i;
		case T[(coordfond.y-50) div 32+1][coordfond.x div 32+1].genre of
				1 : SDL_BlitSurface(terre, NIL, window,@coordfond);
				2 :	SDL_BlitSurface(bordure, NIL, window,@coordfond);				
				3 : SDL_BlitSurface(pierre, NIL, window,@coordfond);
				4 : SDL_BlitSurface(diamant, NIL, window,@coordfond);
				5 : SDL_BlitSurface(port, NIL, window,@coordfond);
				6 : SDL_BlitSurface(spider, NIL, window,@coordfond);			
				0 : SDL_BlitSurface(fond, NIL, window,@coordfond);	
			end;
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

procedure ProcessKeyFin(key : TSDL_KeyboardEvent;var bouge : coordMenu;var window : PSDL_Surface; var fin : Boolean; T:Terrain);
begin
	case key.keysym.sym of
		SDLK_DOWN : begin 
						bouge.choix:= (bouge.choix+1) mod 3;
						bouge.y:=50+4*32+128*bouge.choix;
						affichageFondFin(window, T);
						affichecurseur(window,bouge);
					end;
		SDLK_UP : begin 
						bouge.choix:=(bouge.choix-1+3) mod 3;
						bouge.y:=50+4*32+128*bouge.choix;
						affichageFondFin(window, T);
						affichecurseur(window,bouge);
					end;
		SDLK_RETURN :fin:=True;
	end;
end;


procedure choixFin(var window : PSDL_Surface; var fin, save : Boolean; T : Terrain);
var Resume, SaveQuit, Quit : PSDL_Surface;
	destination_rect : TSDL_Rect;
	choisi : Boolean;
	event : TSDL_Event;
	pos : coordMenu;
begin
	Resume := IMG_Load('ressources/Resume.png');
	SaveQuit := IMG_Load('ressources/SaveQuit.png');
	Quit := IMG_Load('ressources/Quit.png');
	choisi := False;
	destination_rect.x := 200;
	destination_rect.y := 100;
	SDL_BlitSurface ( Resume , NIL , window , @destination_rect );
	
	destination_rect.y := destination_rect.y + 150;
	SDL_BlitSurface ( SaveQuit , NIL , window , @destination_rect );
	
	destination_rect.y := destination_rect.y + 150;
	SDL_BlitSurface ( Quit , NIL , window , @destination_rect );
	
	pos.x:=5*32;
	pos.y:=50+ 4*32;
	affichecurseur( window,pos);
	pos.choix:=0;
	
	SDl_Flip(window);
	while not choisi do
	begin
		SDL_PollEvent (@event);
		if event.type_ = SDL_KEYDOWN then
			processKeyFin ( event.key , pos, window, choisi, T);
		SDL_Delay(100);
	end;
	
	case pos.choix of
		1 : save := True;
		2 : fin := True;
	end;
	
	SDL_FreeSurface( Resume );
	SDL_FreeSurface( SaveQuit );
	SDL_FreeSurface( Quit );
end;

end.
