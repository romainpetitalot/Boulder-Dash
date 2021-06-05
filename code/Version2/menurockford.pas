unit menurockford;

interface

uses SDL, sdl_image, sdl_mixer,sdl_ttf, sysutils;
CONST longueur = 24;
		largueur = 20;
	AUDIO_CHUNKSIZE :INTEGER=4096;
	MVT = 180;

Type coord = record
	x,y: Integer ;
	choix: Integer;
end;

procedure menu(var fin : Boolean;var ch1,ch2 : Integer);

procedure choixFin(var window : PSDL_Surface; var fin, save : Boolean);

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

procedure affichecurseur (var window, curseur : PSDL_SURFACE; position : coord);
var destination_rect : TSDL_RECT ;
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
end;



procedure processKey ( key : TSDL_KeyboardEvent ; var bouge : coord; var window,curseur,menu : PSDL_Surface; var fin : Boolean; var choix : Integer );

begin
	case key.keysym.sym of
		SDLK_DOWN : begin 
						bouge.x:=bouge.x;
						bouge.choix:= (bouge.choix+1) mod 3;
						writeln(bouge.choix);
						bouge.y:=170+MVT*bouge.choix;
						affiche(window,menu);
						affichecurseur(window,curseur,bouge);
														
					end;
		SDLK_UP : begin 
						bouge.x:=bouge.x;
						bouge.choix:=(bouge.choix-1+3) mod 3; //Pour qu'on puisse retourner sur l'option du haut avec la flèche du bas quand on est en bas
						writeln(bouge.choix);
						bouge.y:=170+MVT*bouge.choix;
						affiche(window,menu);
						affichecurseur(window,curseur,bouge);
					end;
		SDLK_RETURN : begin
							case bouge.choix of
								0 : begin
										fin:=True;
										choix := 1;
									end;
								1 : begin
										fin:=True;
										choix := 2;
									end;
								2 : begin
										fin:=True;
										choix := 3;
									end;
							end;
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
var window, fond,fond2 ,curseur: PSDL_Surface;
	event,event2 : TSDL_Event;
	sound : pMIX_MUSIC;
	button: coord;
begin
	initialise(window, fond, fond2);
	fin := False ;
	son(sound);
	affiche ( window,fond );
	button.x:=150;
	button.y:=170;
	affichecurseur( window,curseur,button);
	button.choix:=0;
	while not fin do
	begin
		SDL_DELAY(100);
		SDL_PollEvent (@event);
		if event.type_ = SDL_KEYDOWN then
			processKey ( event.key , button,window,curseur,fond,fin,ch1);
	end;
	if ch1 = 1 then
	begin
		fin := False;
		button.x:=150;
		button.y:=170;
		affiche ( window,fond2 );
		affichecurseur( window,curseur,button);
		while not fin do
			begin
				fin := False;
				SDL_DELAY(100);
				SDL_PollEvent(@event2);
					if event2.type_ = SDL_KEYDOWN then
				processKey ( event2.key , button,window,curseur,fond2,fin,ch2);
			end;
	end
	else if ch1 = 3 then
		HALT;
	termine_musique(sound);
	termine(window, fond, fond2);

end;

procedure choixFin(var window : PSDL_Surface; var fin, save : Boolean);
var Resume, SaveQuit, Quit : PSDL_Surface;
	destination_rect : TSDL_Rect;
begin
	Resume := IMG_Load('ressources/Resume.png');
	SaveQuit := IMG_Load('ressources/SaveQuit.png');
	Quit := IMG_Load('ressources/Quit.png');
	
	destination_rect.x := 200;
	destination_rect.y := 100;
	SDL_BlitSurface ( Resume , NIL , window , @destination_rect );
	
	destination_rect.y := destination_rect.y + 150;
	SDL_BlitSurface ( SaveQuit , NIL , window , @destination_rect );
	
	destination_rect.y := destination_rect.y + 150;
	SDL_BlitSurface ( Quit , NIL , window , @destination_rect );
	
	SDL_Delay(1000);
	

end;

end.
