{ 4. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.
}


program Ejercicio4;

const
	valor_alto = 'ZZZZ';
	
type
	reg_provincia = record
		nombre: string[20];
		alf: integer;
		enc: integer;
	end;
	
	reg_localidad = record
		provincia: string[20];
		codigo: integer;
		alf: integer;
		enc: integer;
	end;
	
	archivo_provincias = file of reg_provincia;
	archivo_localidades = file of reg_localidad;

procedure leer (var localidades: archivo_localidades; var localidad: reg_localidad);
begin
	if not EOF(localidades) then read(localidades, localidad)
	else
		localidad.provincia:= valor_alto;
end;

procedure minimo (var det1, det2: archivo_localidades; var loc1, loc2, min: reg_localidad);
begin
	if (loc1.provincia < loc2.provincia) then begin
		min:= loc1;
		leer(det1, loc1);
	end
	else begin
		min:= loc2;
		leer(det2, loc2);
	end;
end;

procedure actualizarMaestro(var provincias: archivo_provincias; var det1, det2: archivo_localidades);
var
	loc1, loc2, min: reg_localidad; prov: reg_provincia;
	
begin
	reset(provincias);
	reset(det1);
	reset(det2);
	
	leer(det1, loc1); leer(det2, loc2);
	minimo(det1, det2, loc1, loc2, min);
	while (min.provincia <> valor_alto) do begin
		read(provincias, prov);
		while (prov.nombre <> min.provincia) do begin
			read(provincias, prov);
		end;
		while (prov.nombre = min.provincia) do begin
			prov.alf:= prov.alf + min.alf;
			prov.enc:= prov.enc + min.enc;
			minimo(det1, det2, loc1, loc2, min);
		end;
		seek(provincias, filePos(provincias) - 1);
		write(provincias, prov);
	end;
	
	
	close(provincias);
	close(det1);
	close(det2);
end;

procedure crearArchivos (var provincias: archivo_provincias; var det1, det2: archivo_localidades);
var
	prov: reg_provincia; loc: reg_localidad;
	
begin
	rewrite(provincias);
	rewrite(det1);
	rewrite(det2);
	
	prov.nombre:= 'Buenos Aires';
	prov.alf:= 200;
	prov.enc:= 250;
	write(provincias, prov);
	prov.nombre:= 'Santa Fe';
	prov.alf:= 100;
	prov.enc:= 130;
	write(provincias, prov);
	
	loc.provincia:= 'Buenos Aires';
	loc.codigo:= 1;
	loc.alf:= 10;
	loc.enc:= 20;
	write(det1, loc);
	loc.provincia:= 'Buenos Aires';
	loc.codigo:= 2;
	loc.alf:= 20;
	loc.enc:= 40;
	write(det1, loc);
	loc.provincia:= 'Santa Fe';
	loc.codigo:= 3;
	loc.alf:= 20;
	loc.enc:= 30;
	write(det1, loc);
	
	loc.provincia:= 'Buenos Aires';
	loc.codigo:= 4;
	loc.alf:= 40;
	loc.enc:= 50;
	write(det2, loc);
	loc.provincia:= 'Santa Fe';
	loc.codigo:= 5;
	loc.alf:= 10;
	loc.enc:= 30;
	write(det2, loc);
	loc.provincia:= 'Santa Fe';
	loc.codigo:= 6;
	loc.alf:= 60;
	loc.enc:= 80;
	write(det2, loc);
	loc.provincia:= 'Santa Fe';
	loc.codigo:= 7;
	loc.alf:= 35;
	loc.enc:= 45;
	write(det2, loc);
	
	close(provincias);
	close(det1);
	close(det2);
end;

procedure pasarTexto (var provincias: archivo_provincias);
var
	txt: text; prov: reg_provincia; nombre_fisico: string;
	
begin
	writeln(#10, 'Ingrese el nombre del nuevo archivo de texto: ');
	readln(nombre_fisico);
	assign(txt, nombre_fisico+'.txt');
	reset(provincias);
	rewrite(txt);
	
	while not EOF(provincias) do begin
		read(provincias, prov);
		writeln(txt, 'Nombre: ', prov.nombre, ' Alfabetizados: ', prov.alf, ' Encuestados: ', prov.enc);
	end;
	
	close(provincias);
	close(txt);
end;

var
	provincias: archivo_provincias; loc1, loc2: archivo_localidades; 
BEGIN
	assign(provincias, 'provincias');
	assign(loc1, 'localidades1');
	assign(loc2, 'localidades2');
	// Los creo para probarlo (paso a texto para verificar).
	crearArchivos(provincias, loc1, loc2);
	pasarTexto(provincias);
	writeln(#10, 'Actualizando Maestro...');
	actualizarMaestro(provincias, loc1, loc2);
	writeln(#10, 'Maestro actualizado con exito.');
	// Paso de nuevo a texto para comparar resultados.
	pasarTexto(provincias);
END.

