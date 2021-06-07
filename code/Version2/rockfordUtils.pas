unit rockfordUtils;

interface

CONST longueur = 24;
		largueur = 20;
	AUDIO_CHUNKSIZE :INTEGER=4096;
	MVT = 180;


Type coordMenu = record
	x,y: Integer ;
	choix: Integer;
end;



Type coordonnees = record
	x : Integer;
	y : Integer;	
end;

Type block = record
	genre : Integer;
	Used : Boolean;
	mouvement, orientation : String;
end;

Type Terrain = array[1..50,1..50] of block;

implementation

end.
