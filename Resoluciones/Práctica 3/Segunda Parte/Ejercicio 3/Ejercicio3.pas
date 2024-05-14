{3. Suponga que trabaja en una oficina donde está montada una LAN (red local). La
misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y
todas las máquinas se conectan con un servidor central. Semanalmente cada
máquina genera un archivo de logs informando las sesiones abiertas por cada usuario
en cada terminal y por cuánto tiempo estuvo abierta. Cada archivo detalle contiene
los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar un
procedimiento que reciba los archivos detalle y genere un archivo maestro con los
siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.

Notas:
 ● Los archivos detalle no están ordenados por ningún criterio.
 ● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o inclusive, en diferentes máquinas
}


program Ejercicio3;

const
	valor_alto = 9999;
	cantMaquinas = 5;
	
type 
	
	reg_log = record
		codigo: integer;
		fecha: string;
		tiempo: real;
	end;
		
	archivo_logs = file of reg_log;
	vector_archivos = array [1..cantMaquinas] of archivo_logs;
	
procedure leerLog (var archivo: archivo_logs; var reg: reg_log);
begin
	if not EOF(archivo) then read(archivo, reg)
	else reg.codigo:= valor_alto;
end;

procedure crearDetalles (var detalles: vector_archivos);
var
	log: reg_log;
	
begin
	// Detalle 1
	rewrite(detalles[1]);
	
	log.codigo:= 1;
	log.fecha:= '22/03/2024';
	log.tiempo:= 25.2;
	write(detalles[1], log);
	
	log.codigo:= 2;
	log.fecha:= '31/01/2024';
	log.tiempo:= 30;
	write(detalles[1], log);
	
	log.codigo:= 3;
	log.fecha:= '14/07/2023';
	log.tiempo:= 15.5;
	write(detalles[1], log);
		
	close(detalles[1]);
	
	// Detalle 2
	rewrite(detalles[2]);
	
	log.codigo:= 2;
	log.fecha:= '09/04/2024';
	log.tiempo:= 11.5;
	write(detalles[2], log);
	
	log.codigo:= 2;
	log.fecha:= '31/01/2024';
	log.tiempo:= 23.1;
	write(detalles[2], log);
	
	log.codigo:= 3;
	log.fecha:= '14/07/2023';
	log.tiempo:= 35;
	write(detalles[2], log);
		
	close(detalles[2]);
	
	// Detalle 3
	rewrite(detalles[3]);
	
	log.codigo:= 3;
	log.fecha:= '27/07/2023';
	log.tiempo:= 7.3;
	write(detalles[3], log);
	
	log.codigo:= 1;
	log.fecha:= '22/03/2024';
	log.tiempo:= 45.3;
	write(detalles[3], log);
	
	log.codigo:= 2;
	log.fecha:= '31/01/2024';
	log.tiempo:= 25.3;
	write(detalles[3], log);
		
	close(detalles[3]);
	
	// Detalle 4
	rewrite(detalles[4]);
	
	log.codigo:= 3;
	log.fecha:= '14/07/2023';
	log.tiempo:= 56.3;
	write(detalles[4], log);
	
	log.codigo:= 2;
	log.fecha:= '09/04/2024';
	log.tiempo:= 22.2;
	write(detalles[4], log);
	
	log.codigo:= 1;
	log.fecha:= '26/09/2023';
	log.tiempo:= 30.4;
	write(detalles[4], log);
		
	close(detalles[4]);
	
	// Detalle 5
	rewrite(detalles[5]);
	
	log.codigo:= 1;
	log.fecha:= '22/03/2024';
	log.tiempo:= 11.1;
	write(detalles[5], log);
	
	log.codigo:= 2;
	log.fecha:= '09/04/2024';
	log.tiempo:= 12.1;
	write(detalles[5], log);
	
	log.codigo:= 1;
	log.fecha:= '26/09/2023';
	log.tiempo:= 10.1;
	write(detalles[5], log);
		
	close(detalles[5]);
end;

procedure generarMaestro (detalles: vector_archivos; var maestro: archivo_logs);
var
	log, usuario: reg_log; i: integer; found: boolean;

begin
	rewrite(maestro);
	
	for i:= 1 to cantMaquinas do begin
		reset(detalles[i]);
		
		leerLog(detalles[i], log);
		while (log.codigo <> valor_alto) do begin
			seek(maestro, 0);
			found:= false;
			while not EOF(maestro) and not found do begin
				read(maestro, usuario);
				if (usuario.codigo = log.codigo) and (usuario.fecha = log.fecha) then found:= true;
			end;
			if found then begin
				usuario.tiempo:= usuario.tiempo + log.tiempo;
				seek(maestro, filePos(maestro) - 1);
				write(maestro, usuario);
			end
			else write(maestro, log);
			leerLog(detalles[i], log);
		end;
		
		close(detalles[i]);
	end;
	
	close(maestro);
end;

procedure imprimirUsuario (usuario: reg_log);
begin
	writeln('Codigo: ', usuario.codigo);
	writeln('Fecha: ', usuario.fecha);
	writeln('Tiempo total de sesiones: ', usuario.tiempo:4:2);
	writeln();
end;

procedure imprimirMaestro (var maestro: archivo_logs);
var
	usuario: reg_log;
	
begin
	reset(maestro);
	
	writeln('------------- USUARIOS -------------');
	while not EOF(maestro) do begin
		read(maestro, usuario);
		imprimirUsuario(usuario);
	end;
	
	close(maestro);
end;


var
	detalles: vector_archivos; maestro: archivo_logs;
	
BEGIN
	assign(detalles[1], 'Detalle 1');
	assign(detalles[2], 'Detalle 2');
	assign(detalles[3], 'Detalle 3');
	assign(detalles[4], 'Detalle 4');
	assign(detalles[5], 'Detalle 5');
	assign(maestro, 'Maestro');
	
	// Creo el archivo para probar el programa
	crearDetalles(detalles);
	
	// Creo el Maestro
	generarMaestro(detalles, maestro);
	
	// Imprimo para verificar
	imprimirMaestro(maestro);
END.

