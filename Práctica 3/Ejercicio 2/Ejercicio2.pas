{ 2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
 información de asistentes a un congreso a partir de la información obtenida por
 teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
 nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
 archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
 asistente inferior a 1000.
 Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
 String a su elección. Ejemplo: ‘@Saldaño’.
}


program Ejercicio2;

const
	minimo = 1000;
	marca = '?';

type
	reg_asistente = record
		numero: integer;
		nom_ap: string[50];
		email: string[30];
		telefono: integer;
		DNI: integer;
	end;
	
	archivo_congreso = file of reg_asistente;
	
procedure cargarAsistente (var asistente: reg_asistente);
begin
	write('Ingrese numero: ');
	readln(asistente.numero);
	write('Ingrese nombre y apellido: ');
	readln(asistente.nom_ap);
	write('Ingrese email: ');
	readln(asistente.email);
	write('Ingrese telefono: ');
	readln(asistente.telefono);
	write('Ingrese DNI: ');
	readln(asistente.DNI);
	writeln;
end;
	
procedure imprimirAsistente (asistente: reg_asistente);
begin
	writeln('Numero: ', asistente.numero);
	writeln('Nombre y Apellido: ', asistente.nom_ap);
	writeln('Email: ', asistente.email);
	writeln('Telefono: ', asistente.telefono);
	writeln('DNI: ', asistente.DNI);
	writeln;
end;

procedure generarArchivo (var congreso: archivo_congreso);
var
	asistente: reg_asistente;
	
begin
	assign(congreso, 'Archivo Congreso');
	rewrite(congreso);
	cargarAsistente(asistente);
	while (asistente.numero <> -1) do begin
		write(congreso, asistente);
		cargarAsistente(asistente);
	end;
	writeln(#10, 'Carga realizada con exito.');
	close(congreso);
end;

procedure imprimirArchivoReal (var congreso: archivo_congreso);
var
	asistente: reg_asistente;
	
begin
	reset(congreso);
	writeln(#10, '---------- ASISTENTES REALES ----------');
	while not EOF(congreso) do begin
		read(congreso, asistente);
		imprimirAsistente(asistente);
	end;
	close(congreso);
end;

procedure imprimirArchivo (var congreso: archivo_congreso);
var
	asistente: reg_asistente;
	
begin
	reset(congreso);
	writeln(#10, '---------- ASISTENTES ----------');
	while not EOF(congreso) do begin
		read(congreso, asistente);
		if (asistente.email[1] <> marca) then imprimirAsistente(asistente);
	end;
	close(congreso);
end;

procedure eliminarMenosMil (var congreso: archivo_congreso);
var
	asistente: reg_asistente;
	
begin
	reset(congreso);
	while not EOF(congreso) do begin
		read(congreso, asistente);
		if (asistente.numero < minimo) then begin
			asistente.email:= marca + asistente.email;
			seek(congreso, filePos(congreso) - 1);
			write(congreso, asistente);
		end;
	end;
	writeln(#10, 'Limpieza finalizada con exito.');
	close(congreso);
end;


var
	congreso: archivo_congreso;

BEGIN
	writeln('CARGANDO ARCHIVO...');
	generarArchivo(congreso);
	// Verifico la carga
	imprimirArchivo(congreso);
	// Elimino
	writeln('LIMPIANDO ARCHIVO...');
	eliminarMenosMil(congreso);
	// Verifico los resultados
	imprimirArchivo(congreso);
	imprimirArchivoReal(congreso);
END.

