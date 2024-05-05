{ 6. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}


program Ejercicio6;

const
	dimF = 5;
	valor_alto = 9999;

type
	reg_log = record
		cod_usuario: integer;
		fecha: string[10];
		tiempo: real;
	end;
	
	archivo_maestro = file of reg_log;
	archivo_detalle = file of reg_log;
	
	vector_detalles = array [1..dimF] of archivo_detalle;
	vector_reg = array [1..dimF] of reg_log;

procedure leer (var archivo: archivo_detalle; var reg: reg_log);
begin
	if not EOF(archivo) then read(archivo, reg)
	else 
		reg.cod_usuario:= valor_alto;
end;

procedure minimo (var detalles: vector_detalles; var min: reg_log; var reg_d: vector_reg);
var
	pos, i: integer;
begin
	min.cod_usuario:= valor_alto;
	for i:= 1 to dimF do begin
		if (reg_d[i].cod_usuario < min.cod_usuario) then begin
			min:= reg_d[i];
			pos:= i;
		end
		else begin
			if (reg_d[i].cod_usuario = min.cod_usuario) and (reg_d[i].fecha < min.fecha) then begin
				min:= reg_d[i];
				pos:= i
			end;
		end;
	end;
	if (min.cod_usuario <> valor_alto) then	leer(detalles[pos], reg_d[pos]);
end;

procedure crearArchivos (var detalles: vector_detalles);
var
	reg: reg_log; i: integer;
begin
	for i:=1 to 3 do begin 
		rewrite(detalles[i]);
		reg.cod_usuario:= 1;
		reg.fecha:= '01/03/2024';
		reg.tiempo:= 20.5;
		write(detalles[i], reg);
		reg.cod_usuario:= 2;
		reg.fecha:= '01/03/2024';
		reg.tiempo:= 50;
		write(detalles[i], reg);
		reg.cod_usuario:= 2;
		reg.fecha:= '24/04/2024';
		reg.tiempo:= 45.5;
		write(detalles[i], reg);
		close(detalles[i]);
	end;
		
	for i:=4 to 5 do begin 
		rewrite(detalles[i]);
		reg.cod_usuario:= 2;
		reg.fecha:= '01/03/2024';
		reg.tiempo:= 25;
		write(detalles[i], reg);
		reg.cod_usuario:= 3;
		reg.fecha:= '21/03/2024';
		reg.tiempo:= 50;
		write(detalles[i], reg);
		reg.cod_usuario:= 5;
		reg.fecha:= '13/03/2024';
		reg.tiempo:= 43.2;
		write(detalles[i], reg);
		close(detalles[i]);
	end;
end;

procedure imprimirDetalles (var detalles: vector_detalles);
var
	reg: reg_log; i: integer;
begin
	for i:=1 to dimF do begin
		reset(detalles[i]);
		writeln('---------------- DETALLE ', i, ' ----------------');
		writeln;
		while not EOF(detalles[i]) do begin
			read(detalles[i], reg);
			writeln('Codigo: ', reg.cod_usuario);
			writeln('Fecha: ', reg.fecha);
			writeln('Tiempo Sesion: ', reg.tiempo:10:2, ' min.');
			writeln;
		end;
		writeln;
		close(detalles[i]);
	end;
end;

procedure imprimirMaestro (var maestro: archivo_maestro);
var
	reg: reg_log;
begin
	reset(maestro);
	
	writeln('---------------- MAESTRO ----------------');
	writeln;
	while not EOF(maestro) do begin
		read(maestro, reg);
		writeln('Codigo: ', reg.cod_usuario);
		writeln('Fecha: ', reg.fecha);
		writeln('Tiempo Total: ', reg.tiempo:10:2, ' min.');
		writeln;
	end;
	
	close(maestro);
end;

procedure crearMaestro (var maestro: archivo_maestro; var detalles: vector_detalles; var reg_d: vector_reg);
var
	i: integer; min, aux: reg_log;
begin
	rewrite(maestro);
	for i:=1 to dimF do begin
		reset(detalles[i]);
		leer(detalles[i], reg_d[i]);
	end;
	
	minimo(detalles, min, reg_d);
	
	while min.cod_usuario <> valor_alto do begin
		aux.cod_usuario:= min.cod_usuario;
		while (min.cod_usuario = aux.cod_usuario) do begin
			aux.fecha:= min.fecha;
			aux.tiempo:= 0;
			while (min.cod_usuario = aux.cod_usuario) and (min.fecha = aux.fecha) do begin
				aux.tiempo:= aux.tiempo + min.tiempo;
				minimo(detalles, min, reg_d);
			end;
			write(maestro, aux);
		end;
	end;
			
	close(maestro);
	for i:=1 to dimF do close(detalles[i]);
end;

var
	maestro: archivo_maestro; detalles: vector_detalles; reg_d: vector_reg;

BEGIN
	assign(detalles[1], 'detalle1');
	assign(detalles[2], 'detalle2');
	assign(detalles[3], 'detalle3');
	assign(detalles[4], 'detalle4');
	assign(detalles[5], 'detalle5');
	assign(maestro, 'maestro');
	
	// Creo los archivos para probar y los imprimo
	crearArchivos(detalles);
	imprimirDetalles(detalles);
	
	// Creo el maestro
	crearMaestro(maestro, detalles, reg_d);
	
	// Imprimo para verificar
	imprimirMaestro(maestro);
END.

