{ Realizar un programa que presente un menú con opciones para:
 a. Crear un archivo de registros no ordenados de empleados y completarlo con
 datos ingresados desde teclado. De cada empleado se registra: número de
 empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
 DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

 b. Abrir el archivo anteriormente generado y...
 i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado, el cual se proporciona desde el teclado.
 ii. Listar en pantalla los empleados de a uno por línea.
 iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
 NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.
}

program Ejercicio3;

const
	fin = 'fin';
	jubilacion = 70;

type
	reg_empleados = record
		numero: integer;
		apellido: string[20];
		nombre: string[20];
		edad: integer;
		DNI: string[8];
	end;
	
	archivo_empleados = file of reg_empleados;
	
procedure ImprimirEmpleado (emple: reg_empleados);
begin
	write('Apellido: ', emple.apellido, #10, 'Nombre: ', emple.nombre, #10, 'Numero: ', emple.numero, #10, 'Edad: ', emple.edad, #10, 'DNI: ', emple.DNI, #10);
end;

procedure CrearArchivo (var empleados: archivo_empleados);
var
	nombre_fisico: string;
	emple: reg_empleados;
	
begin
	write('Ingrese el nombre del nuevo archivo: ');
	readln(nombre_fisico);
	assign (empleados, nombre_fisico);
	rewrite (empleados);
	
	write(#10, 'Ingrese apellido: ');
	readln(emple.apellido);
	while (emple.apellido <> fin) do begin
		write(#10, 'Ingrese nombre: ');
		readln(emple.nombre);
		write(#10, 'Ingrese numero: ');
		readln(emple.numero);
		write(#10, 'Ingrese edad: ');
		readln(emple.edad);
		write(#10, 'Ingrese DNI: ');
		readln(emple.DNI);
		write(empleados, emple);
		write(#10, 'Ingrese apellido: ');
		readln(emple.apellido);
	end;
	
	writeln(#10, 'Carga completada.');
	close(empleados);
end;

procedure AbrirArchivo (var empleados: archivo_empleados);
	procedure Especifico (var empleados: archivo_empleados);
	var
		dato: string; emple: reg_empleados;
		
	begin
		reset (empleados);
		
		write(#10, 'Ingrese el apellido o nombre a buscar: ');
		readln(dato);
		while not EOF(empleados) do begin
			read(empleados, emple);
			if (emple.nombre = dato) or (emple.apellido = dato) then
				ImprimirEmpleado(emple);
		end;
				
		close(empleados);
	end;
	
	procedure Contenido (var empleados: archivo_empleados);
	var
		emple: reg_empleados;
	begin
		reset (empleados);
		
		while not EOF(empleados) do begin
			read(empleados, emple);
			ImprimirEmpleado(emple);
		end;	
		
		close(empleados);
	end;
	
	procedure Mayores (var empleados: archivo_empleados);
	var
		emple: reg_empleados;
	begin
		reset (empleados);
		
		while not EOF(empleados) do begin
			read(empleados, emple);
			if (emple.edad > jubilacion) then ImprimirEmpleado(emple);
		end;
		
		close(empleados);
	end;
	
var
	nombre_fisico: string; opcion: integer;
	
begin
	write('Ingrese el nombre del archivo: ');
	readln(nombre_fisico);
	assign (empleados, nombre_fisico);
	write(#10, 'Seleccione la opcion deseada', #10, '1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.', #10, '2. Listar en pantalla los empleados de a uno por linea.', #10, '3. Listar en pantalla los empleados mayores de 70, proximos a jubilarse.', #10); 
	readln(opcion);
	case opcion of
		1: Especifico (empleados);
		2: Contenido (empleados);
		3: Mayores (empleados);
	else write('El numero ingresado no corresponde con ninguna opcion.');
	end;
end;

var
	empleados: archivo_empleados;
	opcion: integer;
	
BEGIN
	repeat
		write('Seleccione la opcion deseada', #10, '1. Crear archivo.', #10, '2. Abrir archivo.', #10, '3. Salir.', #10);
		readln(opcion);
		case opcion of
			1: CrearArchivo (empleados);
			2: AbrirArchivo (empleados);
			3: writeln('Cerrando menu...');
		else write('El numero ingresado no corresponde con ninguna opcion.');
		end;
	until opcion = 3;
END.

