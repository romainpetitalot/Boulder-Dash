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

procedure menu(var fin : Boolean;var choix : Integer);

implementation

procedure initialise( var window, menu : PSDL_Surface);
begin
	SDL_Init(SDL_INIT_VIDEO + SDL_INIT_AUDIO);
	SDL_putenv('SDL_VIDEO_WINDOW_POS=center');
	window := SDL_SetVideoMode(32*longueur, 32*largueur, 32, SDL_DOUBLEBUF + SDL_HWSURFACE + SDL_NOFRAME);
	
	menu := IMG_Load('ressources/fond1.png');
	
end;


procedure termine ( var window , menu : PSDL_SURFACE );
begin
	{ vider la memoire correspondant a l ’ image et a la fenetre }
	SDL_FreeSurface ( menu );
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

procedure affichepara(var window,reg : PSDL_SURFACE; position : coord);
var destination_rect : TSDL_RECT ;
begin
	reg:= IMG_Load('ressources/encours.png');
	{ Choix de la position et taille de l ’ element a afficher }
	destination_rect.x := 0  ;
	destination_rect.y := 0  ;
	destination_rect.w := 32*longueur ;
	destination_rect.h := 32*largueur ;
	{ Coller l ’ element dans la fenetre window avec les caracteristiques destination_rect }
	SDL_BlitSurface ( reg , NIL , window , @destination_rect );
	{ Afficher la nouvelle image }
	SDL_Flip ( window )
end;


procedure processKey ( key : TSDL_KeyboardEvent ; var bouge : coord; var window,curseur,menu,reg : PSDL_Surface; var fin : Boolean; var choix : Integer );

begin
	case key.keysym.sym of
		SDLK_DOWN : begin bouge.x:=bouge.x;
							bouge.y:=bouge.y+MVT;
							bouge.choix:=bouge.choix+1;
							affiche(window,menu);
							affichecurseur(window,curseur,bouge);
								
					end;
		SDLK_UP : begin 
						bouge.x:=bouge.x;
							bouge.y:=bouge.y-MVT;
							bouge.choix:=bouge.choix-1;
							affiche(window,menu);
							affichecurseur(window,curseur,bouge);
							
					end;
		SDLK_RETURN : begin
							case bouge.choix of
								1 : begin
										fin:=True;
										choix := 1;
									end;
								2 : begin
										fin:=True;
{
										affichepara(window,reg,bouge);
}
										choix := 2;
									end;
								3 : begin
										HALT;
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

procedure menu(var fin : Boolean;var choix : Integer);

var window, fond ,curseur,parametres: PSDL_Surface;
	event : TSDL_Event;
	sound : pMIX_MUSIC;
	button: coord;

begin
	initialise(window, fond);
	fin := False ;
	son(sound);
	{ On se limite a 100 fps . }
		SDL_Delay (100);
		{ On affiche la scene }
		affiche ( window,fond );
		button.x:=150;
		button.y:=170;
		affichecurseur( window,curseur,button);
		button.choix:=1;
	while not fin do
	begin
		SDL_DELAY(100);
		{ On lit un evenement et on agit en consequence }
		SDL_PollEvent (@event);
		if event.type_ = SDL_KEYDOWN then
			processKey ( event.key , button,window,curseur,fond,parametres,fin,choix);
	end;
termine_musique(sound);
termine(window, fond);

end;

end.
