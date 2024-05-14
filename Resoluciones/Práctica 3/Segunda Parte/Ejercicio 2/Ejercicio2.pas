{ 2. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:
 Código de Localidad | Total de Votos
 ...................   ............
 ...................   ............
 Total General de Votos: -

NOTAS:
 ● La información en el archivo no está ordenada por ningún criterio.
 ● Trate de resolver el problema sin modificar el contenido del archivo dado.
 ● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
 llevar el control de las localidades que han sido procesadas.
}


program Ejercicio2;

const
	valor_alto = 9999;

type
	reg_localidad = record
		codigo: integer;
		numero: integer;
		votos: integer;
	end;
	
	reg_total = record
		codigo: integer;
		votos: integer;
	end;
	
	archivo_votos = file of reg_localidad;
	archivo_contador = file of reg_total;


procedure leerVoto (var votos: archivo_votos; var localidad: reg_localidad);
begin
	if not EOF(votos) then read(votos, localidad)
	else localidad.codigo:= valor_alto;
end;

procedure crearVotos (var votos: archivo_votos);
var
	localidad: reg_localidad;

begin
	assign(votos, 'Archivo de Votos');
	rewrite(votos);

	localidad.codigo := 80;
	localidad.numero := 240;
	localidad.votos := 250;
	write(votos, localidad);

	localidad.codigo := 10;
	localidad.numero := 105;
	localidad.votos := 200;
	write(votos, localidad);

	localidad.codigo := 40;
	localidad.numero := 150;
	localidad.votos := 220;
	write(votos, localidad);

	localidad.codigo := 10;
	localidad.numero := 190;
	localidad.votos := 270;
	write(votos, localidad);

	localidad.codigo := 85;
	localidad.numero := 250;
	localidad.votos := 290;
	write(votos, localidad);

	localidad.codigo := 15;
	localidad.numero := 112;
	localidad.votos := 300;
	write(votos, localidad);

	localidad.codigo := 10;
	localidad.numero := 130;
	localidad.votos := 150;
	write(votos, localidad);

	localidad.codigo := 40;
	localidad.numero := 170;
	localidad.votos := 190;
	write(votos, localidad);

	localidad.codigo := 90;
	localidad.numero := 260;
	localidad.votos := 270;
	write(votos, localidad);

	localidad.codigo := 40;
	localidad.numero := 140;
	localidad.votos := 180;
	write(votos, localidad);

	close(votos);
end;

procedure contarVotos (var votos: archivo_votos; var contador: archivo_contador);
var
	total: reg_total; localidad: reg_localidad; found: boolean;
	
begin
	reset(votos);
	assign(contador, 'Contador de Votos');
	rewrite(contador);
	
	leerVoto(votos, localidad);
	while (localidad.codigo <> valor_alto) do begin
		seek(contador, 0);
		found:= false;
		while not EOF(contador) and not found do begin
			read(contador, total);
			if (total.codigo = localidad.codigo) then begin
				found:= true;
			end;
		end;
		if found then begin
			total.votos:= total.votos + localidad.votos;
			seek(contador, filePos(contador) - 1);
		end
		else begin
			total.codigo:= localidad.codigo;
			total.votos:= localidad.votos;
		end;
		write(contador, total);
		leerVoto(votos, localidad);
	end;
	
	close(votos);
	close(contador);
end;

procedure imprimirVotos (var contador: archivo_contador);
var
	total: reg_total; general: integer;

begin
	reset(contador);
	
	general:= 0;
	writeln(#10, '----------------- RESULTADOS -----------------');
	while not EOF(contador) do begin
		read(contador, total);
		general:= general + total.votos;
		writeln(#10, 'Codigo de Localidad: ', total.codigo, ' - Total de Votos: ', total.votos);
	end;
	writeln(#10, '----------------------------------------------', #10);
	writeln('- Total General de votos: ', general);
	
	close(contador);
end;


var
	votos: archivo_votos; contador: archivo_contador;

BEGIN
	// Creo el archivo para probarlo
	crearVotos(votos);
	
	// Recuento los votos
	contarVotos(votos, contador);
	
	// Imprimo los resultados
	imprimirVotos(contador);
END.

