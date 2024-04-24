{9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___
NOTA: La información está ordenada por código de provincia y código de localidad.
}


program Ejercicio9;

const
	valor_alto = 9999;

type
	reg_mesa = record
		cod_prov: integer;
		cod_loc: integer;
		numero: integer;
		votos: integer;
	end;
	
	archivo_elecciones = file of reg_mesa;

procedure leer (var archivo: archivo_elecciones; var reg: reg_mesa);
begin
	if not EOF(archivo) then read(archivo, reg)
	else 
		reg.cod_prov:= valor_alto;
end;

procedure crearArchivo (var archivo: archivo_elecciones);
var
	reg: reg_mesa;
	
begin
	rewrite(archivo);
	
	reg.cod_prov:= 1;
	reg.cod_loc:= 1;
	reg.numero:= 10;
	reg.votos:= 20;
	write(archivo, reg);
	
	reg.cod_prov:= 1;
	reg.cod_loc:= 1;
	reg.numero:= 24;
	reg.votos:= 34;
	write(archivo, reg);
	
	reg.cod_prov:= 1;
	reg.cod_loc:= 2;
	reg.numero:= 12;
	reg.votos:= 15;
	write(archivo, reg);
	
	reg.cod_prov:= 2;
	reg.cod_loc:= 4;
	reg.numero:= 26;
	reg.votos:= 43;
	write(archivo, reg);
	
	reg.cod_prov:= 2;
	reg.cod_loc:= 6;
	reg.numero:= 73;
	reg.votos:= 38;
	write(archivo, reg);
	
	reg.cod_prov:= 3;
	reg.cod_loc:= 7;
	reg.numero:= 43;
	reg.votos:= 74;
	write(archivo, reg);
	
	reg.cod_prov:= 3;
	reg.cod_loc:= 8;
	reg.numero:= 58;
	reg.votos:= 23;
	write(archivo, reg);
	
	reg.cod_prov:= 3;
	reg.cod_loc:= 11;
	reg.numero:= 65;
	reg.votos:= 134;
	write(archivo, reg);
	
	close(archivo);
end;

procedure imprimirDatos (var archivo: archivo_elecciones);
var
	reg: reg_mesa; total, total_prov, total_loc: integer;
	prov, loc: integer;

begin
	reset(archivo);
	
	writeln('---------------- RECUENTO DE VOTOS ----------------');
	leer(archivo, reg);
	total:= 0;
	while (reg.cod_prov <> valor_alto) do begin
		prov:= reg.cod_prov;
		total_prov:= 0;
		writeln;
		writeln('Codigo de Provincia: ', prov);
		writeln;
		while (reg.cod_prov = prov) do begin
			loc:= reg.cod_loc;
			total_loc:= 0;
			while (reg.cod_prov = prov) and (reg.cod_loc = loc) do begin
				total_loc:= total_loc + reg.votos;
				leer(archivo, reg);
			end;
			writeln('    Codigo de Localidad: ', loc, ' - Total de Votos: ', total_loc);
			writeln;
			total_prov:= total_prov + total_loc;
		end;
		total:= total + total_prov;
		writeln('Total de Votos Provincial: ', total_prov);
		writeln;
	end;
	writeln('---------------------------------------------------');
	writeln;
	writeln('Total de General de Votos: ', total);
	writeln;
	
	close(archivo);
end;

var
	archivo: archivo_elecciones;
	
BEGIN
	assign(archivo, 'Elecciones 2024');
	
	// Creo el archivo para probar el programa
	crearArchivo(archivo);
	
	// Imprimo lo pedido
	imprimirDatos(archivo);
END.

