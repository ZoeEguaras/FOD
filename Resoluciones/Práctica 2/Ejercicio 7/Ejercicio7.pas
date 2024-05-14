{ 7. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).
}


program Ejercicio7;

const
	valor_alto = 9999;
	dimF = 10;

type
	reg_municipio = record
		localidad_cod: integer;
		cepa_cod: integer;
		casos_activos: integer;
		casos_nuevos: integer;
		casos_recuperados: integer;
		casos_fallecidos: integer;
	end;
	
	reg_ministerio = record
		localidad_cod: integer;
		localidad_nom: string[20];
		cepa_cod: integer;
		cepa_nom: string[20];
		casos_activos: integer;
		casos_nuevos: integer;
		casos_recuperados: integer;
		casos_fallecidos: integer;
	end;
	
	archivo_ministerio = file of reg_ministerio;
	archivo_municipio = file of reg_municipio;
	
	vector_registros = array [1..dimF] of reg_municipio;
	vector_municipios = array [1..dimF] of archivo_municipio;

procedure leer (var archivo: archivo_municipio; var reg: reg_municipio);
begin
	if not EOF(archivo) then read(archivo, reg)
	else 
		reg.localidad_cod:= valor_alto;
end;

procedure minimo (var detalles: vector_municipios; var min: reg_municipio; var reg_d: vector_registros);
var
	pos, i: integer;
begin
	min.localidad_cod:= valor_alto;
	for i:= 1 to dimF do begin
		if (reg_d[i].localidad_cod < min.localidad_cod) or ((reg_d[i].localidad_cod = min.localidad_cod) and (reg_d[i].cepa_cod < min.cepa_cod)) then begin
			min:= reg_d[i];
			pos:= i;
		end;
	end;
	if (min.localidad_cod <> valor_alto) then leer(detalles[pos], reg_d[pos]);
end;

procedure crearDetalles (var detalles: vector_municipios);
var
	reg: reg_municipio; i: integer;
begin
	for i:=1 to 5 do begin 
		rewrite(detalles[i]);
		reg.localidad_cod:= 1;
		reg.cepa_cod:= 2;
		reg.casos_activos:= 10;
		reg.casos_nuevos:= 13;
		reg.casos_recuperados:= 11;
		reg.casos_fallecidos:= 4;
		write(detalles[i], reg);
		
		reg.localidad_cod:= 2;
		reg.cepa_cod:= 2;
		reg.casos_activos:= 20;
		reg.casos_nuevos:= 15;
		reg.casos_recuperados:= 10;
		reg.casos_fallecidos:= 5;
		write(detalles[i], reg);
		
		reg.localidad_cod:= 3;
		reg.cepa_cod:= 3;
		reg.casos_activos:= 5;
		reg.casos_nuevos:= 2;
		reg.casos_recuperados:= 3;
		reg.casos_fallecidos:= 2;
		write(detalles[i], reg);
		close(detalles[i]);
	end;
		
	for i:=6 to 10 do begin 
		rewrite(detalles[i]);
		reg.localidad_cod:= 2;
		reg.cepa_cod:= 1;
		reg.casos_activos:= 30;
		reg.casos_nuevos:= 9;
		reg.casos_recuperados:= 23;
		reg.casos_fallecidos:= 9;
		write(detalles[i], reg);
		
		reg.localidad_cod:= 2;
		reg.cepa_cod:= 2;
		reg.casos_activos:= 24;
		reg.casos_nuevos:= 12;
		reg.casos_recuperados:= 8;
		reg.casos_fallecidos:= 3;
		write(detalles[i], reg);
		
		reg.localidad_cod:= 3;
		reg.cepa_cod:= 1;
		reg.casos_activos:= 6;
		reg.casos_nuevos:= 2;
		reg.casos_recuperados:= 4;
		reg.casos_fallecidos:= 2;
		write(detalles[i], reg);
		close(detalles[i]);
	end;
end;

procedure imprimirDetalles (var detalles: vector_municipios);
var
	reg: reg_municipio; i: integer;
begin
	for i:=1 to dimF do begin
		reset(detalles[i]);
		writeln('---------------- DETALLE ', i,  ' ----------------');
		writeln;
		while not EOF(detalles[i]) do begin
			read(detalles[i], reg);
			writeln('Codigo de Localidad: ', reg.localidad_cod);
			writeln('Codigo de Cepa: ', reg.cepa_cod);
			writeln('Casos Activos: ', reg.casos_activos);
			writeln('Casos Nuevos: ', reg.casos_nuevos);
			writeln('Casos Recuperados: ', reg.casos_recuperados);
			writeln('Casos Fallecidos: ', reg.casos_fallecidos);
			writeln;
		end;
		writeln;
		close(detalles[i]);
	end;
end;

procedure crearMaestro (var maestro: archivo_ministerio);
var
	reg: reg_ministerio;
begin
	rewrite(maestro);
	
	reg.localidad_cod:= 1;
	reg.localidad_nom:= 'La Plata';
	reg.cepa_cod:= 2;
	reg.cepa_nom:= 'Azul';
	reg.casos_activos:= 10;
	reg.casos_nuevos:= 13;
	reg.casos_recuperados:= 11;
	reg.casos_fallecidos:= 4;
	write(maestro, reg);
	
	reg.localidad_cod:= 2;
	reg.localidad_nom:= 'La Matanza';
	reg.cepa_cod:= 1;
	reg.cepa_nom:= 'Verde';
	reg.casos_activos:= 13;
	reg.casos_nuevos:= 4;
	reg.casos_recuperados:= 24;
	reg.casos_fallecidos:= 10;
	write(maestro, reg);
	
	reg.localidad_cod:= 2;
	reg.localidad_nom:= 'La Matanza';
	reg.cepa_cod:= 2;
	reg.cepa_nom:= 'Azul';
	reg.casos_activos:= 9;
	reg.casos_nuevos:= 3;
	reg.casos_recuperados:= 7;
	reg.casos_fallecidos:= 2;
	write(maestro, reg);
	
	reg.localidad_cod:= 3;
	reg.localidad_nom:= 'Tigre';
	reg.cepa_cod:= 1;
	reg.cepa_nom:= 'Verde';
	reg.casos_activos:= 23;
	reg.casos_nuevos:= 21;
	reg.casos_recuperados:= 37;
	reg.casos_fallecidos:= 19;
	write(maestro, reg);
	
	reg.localidad_cod:= 3;
	reg.localidad_nom:= 'Tigre';
	reg.cepa_cod:= 3;
	reg.cepa_nom:= 'Roja';
	reg.casos_activos:= 22;
	reg.casos_nuevos:= 17;
	reg.casos_recuperados:= 38;
	reg.casos_fallecidos:= 14;
	write(maestro, reg);
	
	close(maestro);
end;

procedure imprimirMaestro (var maestro: archivo_ministerio);
var
	reg: reg_ministerio;
begin
	reset(maestro);
	
	writeln('---------------- MAESTRO ----------------');
	writeln;
	while not EOF(maestro) do begin
		read(maestro, reg);
		writeln('Codigo de Localidad: ', reg.localidad_cod);
		writeln('Nombre de Localidad: ', reg.localidad_nom);
		writeln('Codigo de Cepa: ', reg.cepa_cod);
		writeln('Nombre de Cepa: ', reg.cepa_nom);
		writeln('Casos Activos: ', reg.casos_activos);
		writeln('Casos Nuevos: ', reg.casos_nuevos);
		writeln('Casos Recuperados: ', reg.casos_recuperados);
		writeln('Casos Fallecidos: ', reg.casos_fallecidos);
		writeln;
	end;
	
	close(maestro);
end;

procedure actualizarMaestro (var maestro: archivo_ministerio; var detalles: vector_municipios; var reg_d: vector_registros);
var
	i: integer; min, aux: reg_municipio; mae: reg_ministerio;
	
begin
	reset(maestro);
	for i:= 1 to dimF do begin
		reset(detalles[i]);
		leer(detalles[i], reg_d[i]);
	end;
	
	minimo(detalles, min, reg_d);
	
	while (min.localidad_cod <> valor_alto) do begin
		read(maestro, mae);
		while (mae.localidad_cod <> min.localidad_cod) and (mae.cepa_cod <> min.cepa_cod) do begin
			read(maestro, mae);
		end;
		aux:= min;
		aux.casos_activos:= 0;
		aux.casos_nuevos:= 0;
		aux.casos_fallecidos:= 0;
		aux.casos_recuperados:= 0;
		while (min.localidad_cod = aux.localidad_cod) and (min.cepa_cod = aux.cepa_cod)do begin
			aux.casos_activos:= aux.casos_activos + min.casos_activos;
			aux.casos_nuevos:= aux.casos_nuevos + min.casos_nuevos;
			aux.casos_fallecidos:= aux.casos_fallecidos + min.casos_fallecidos;
			aux.casos_recuperados:= aux.casos_recuperados + min.casos_recuperados;
			minimo(detalles, min, reg_d);
		end;
		mae.casos_activos:= mae.casos_activos + aux.casos_activos;
		mae.casos_nuevos:= mae.casos_nuevos + aux.casos_nuevos;
		mae.casos_fallecidos:= mae.casos_fallecidos + aux.casos_fallecidos;
		mae.casos_recuperados:= mae.casos_recuperados + aux.casos_recuperados;
		seek(maestro, filePos(maestro) - 1);
		write(maestro, mae);
	end;
	
	writeln('Archivo Maestro actualizado con exito.');
	writeln;
	
	close(maestro);
	for i:= 1 to dimF do close(detalles[i]);
end;

procedure leerMaestro (var archivo: archivo_ministerio; var reg: reg_ministerio);
begin
	if not EOF(archivo) then read(archivo, reg)
	else 
		reg.localidad_cod:= valor_alto;
end;

procedure localidadesMayores (var maestro: archivo_ministerio);
var
	reg: reg_ministerio; codigo, total: integer; nombre: string[20];
begin
	reset(maestro);
	
	writeln('--------------- LOCALIDADES ---------------');
	writeln;
	leerMaestro(maestro, reg);
	while (reg.localidad_cod <> valor_alto) do begin
		codigo:= reg.localidad_cod;
		nombre:= reg.localidad_nom;
		total:= 0;
		while (codigo = reg.localidad_cod) do begin
			total:= total + reg.casos_activos;
			leerMaestro(maestro, reg);
		end;
		if (total > 50) then begin
			writeln('Localidad: ', nombre);
			writeln('Casos activos: ', total);
			writeln;
		end;
	end;
	
	close(maestro);
end;

var
	maestro: archivo_ministerio; detalles: vector_municipios; reg_d: vector_registros;

BEGIN
	assign(maestro, 'ministerio');
	assign(detalles[1], 'municipio1');
	assign(detalles[2], 'municipio2');
	assign(detalles[3], 'municipio3');
	assign(detalles[4], 'municipio4');
	assign(detalles[5], 'municipio5');
	assign(detalles[6], 'municipio6');
	assign(detalles[7], 'municipio7');
	assign(detalles[8], 'municipio8');
	assign(detalles[9], 'municipio9');
	assign(detalles[10], 'municipio10');
	
	// Creo los detalles y el maestro para probar
	crearDetalles(detalles);
	crearMaestro(maestro);
	
	// Los imprimo para verificar la información
	imprimirDetalles(detalles);
	imprimirMaestro(maestro);
	
	// Actualizo el maestro y lo imprimo para verificar
	writeln('-----------------------------------------');
	writeln;
	actualizarMaestro(maestro, detalles, reg_d);
	imprimirMaestro(maestro);
	
	// Imprimo las localidades con más de 50 casos activos
	localidadesMayores(maestro);
END.
