{ 1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.
}


program Ejercicio1;

const
	valor_alto = 9999;
	
type
	reg_empleado = record
		codigo: integer;
		nombre: string;
		monto: real;
	end;
	
	archivo_empleados = file of reg_empleado;
	
procedure leer (var empleados: archivo_empleados; var empleado: reg_empleado);
begin
	if not EOF(empleados) then read(empleados, empleado)
	else
		empleado.codigo:= valor_alto;
end;

procedure compactarArchivo (var empleados_comisiones: archivo_empleados; var empleados_compact: archivo_empleados);
var
	empleado, actual: reg_empleado;
	
begin
	reset(empleados_comisiones);
	rewrite(empleados_compact);
	
	leer(empleados_comisiones, empleado);
	while (empleado.codigo <> valor_alto) do begin
		actual:= empleado;
		actual.monto:= 0;
		while (empleado.codigo = actual.codigo) do begin
			actual.monto:= actual.monto + empleado.monto;
			leer(empleados_comisiones, empleado);
		end;
		write(empleados_compact, actual);
	end;

	writeln(#10, 'Archivo compactado con exito.');
	close(empleados_comisiones);
	close(empleados_compact);
end;

procedure convertirTexto (var empleados: archivo_empleados; nombre_fisico: string);
var
	txt: text; empleado: reg_empleado;
	
begin
	reset(empleados);
	assign(txt, nombre_fisico);
	rewrite(txt);
	while not EOF(empleados) do begin
		read(empleados, empleado);
		writeln(txt, empleado.codigo, ' ', empleado.nombre);
		writeln(txt, empleado.monto:4:2);
	end;
	
	close(empleados);
	close(txt);
end;

var
	empleados_comisiones, empleados_compact: archivo_empleados; nombre_fisico: string; empleado: reg_empleado; i: integer;
BEGIN
	writeln('Ingrese el nombre del archivo de comisiones: ');
	readln(nombre_fisico);
	assign(empleados_comisiones, nombre_fisico);
	
	// Creo un archivo para probar el programa.
	rewrite(empleados_comisiones);
	for i:= 1 to 6 do begin
		readln(empleado.codigo);
		readln(empleado.nombre);
		readln(empleado.monto);
		write(empleados_comisiones, empleado);
	end;
	close(empleados_comisiones);
	
	writeln('Ingrese el nombre del nuevo archivo: ');
	readln(nombre_fisico);
	assign(empleados_compact, nombre_fisico);
	compactarArchivo(empleados_comisiones, empleados_compact);
	
	// Convierto a texto para ver si funciona bien.
	convertirTexto(empleados_comisiones, 'comisiones.txt');
	convertirTexto(empleados_compact, 'compact.txt');
END.

