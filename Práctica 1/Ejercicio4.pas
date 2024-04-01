{4. Agregar al menú del programa del ejercicio 3, opciones para:
 a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
 teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
 un número de empleado ya registrado (control de unicidad).
 b. Modificar la edad de un empleado dado.
 c. Exportar el contenido del archivo a un archivo de texto llamado
 “todos_empleados.txt”.
 d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
 que no tengan cargado el DNI (DNI en 00) 
}


program Ejercicio4;

const
	fin = 'fin';
	jubilacion = 70;

type
	reg_empleados = record
		apellido: string[20];
		nombre: string[20];
		numero: integer;
		edad: integer;
		DNI: integer;
	end;
	
	archivo_empleados = file of reg_empleados;

procedure CargarEmpleado (var emple: reg_empleados);
begin
	write('Ingrese apellido: ');
	readln(emple.apellido);
	write('Ingrese nombre: ');
	readln(emple.nombre);
	write('Ingrese numero: ');
	readln(emple.numero);
	write('Ingrese edad: ');
	readln(emple.edad);
	write('Ingrese DNI: ');
	readln(emple.DNI);
	writeln;
end;
	
procedure ImprimirEmpleado (emple: reg_empleados);
begin
	writeln('Apellido: ', emple.apellido);
	writeln('Nombre: ', emple.nombre);
	writeln('Numero: ', emple.numero);
	writeln('Edad: ', emple.edad);
	writeln('DNI: ', emple.DNI);
	writeln;
end;

procedure CrearArchivo (var empleados: archivo_empleados);
var
	emple: reg_empleados;
	
begin
	rewrite (empleados);
	
	CargarEmpleado(emple);
	while (emple.apellido <> fin) do begin
		write(empleados, emple);
		CargarEmpleado(emple);
	end;
	
	writeln('Carga completada.');
	writeln;
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
		writeln;
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
		
		writeln (#10, '--------- LISTA DE EMPLEADOS ---------');
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
		
		writeln;
		while not EOF(empleados) do begin
			read(empleados, emple);
			if (emple.edad > jubilacion) then ImprimirEmpleado(emple);
		end;
		
		close(empleados);
	end;
	
var
	opcion: integer;
	
begin
	writeln(#10, 'Seleccione la opcion deseada:');
	writeln('1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
	writeln('2. Listar en pantalla los empleados de a uno por linea.');
	writeln('3. Listar en pantalla los empleados mayores de 70, proximos a jubilarse.'); 
	readln(opcion);
	case opcion of
		1: Especifico (empleados);
		2: Contenido (empleados);
		3: Mayores (empleados);
	else begin
		write('El numero ingresado no corresponde con ninguna opcion.');
		writeln;
	end;
	end;
end;

procedure AgregarEmpleados (var empleados: archivo_empleados);
var
	emple, dato: reg_empleados; no_existe: boolean;
begin
	reset (empleados);
	
	writeln;
	CargarEmpleado(emple);
	while (emple.apellido <> fin) do begin
		no_existe:= True;
		while not EOF(empleados) and no_existe do begin
			read(empleados, dato);
			if (dato.numero = emple.numero) then no_existe:= False;
		end;
		if no_existe then begin 
			write(empleados, emple);
			write('Empleado cargado con exito.');
			writeln;
			seek(empleados, 0);
			CargarEmpleado(emple);
		end
		else begin 
			writeln;
			write('El empleado ingresado ya esta registrado.');
			writeln;
			CargarEmpleado(emple);
		end;
	end;
	
	writeln('Carga completada.');
	writeln;
	close(empleados);
end;

procedure ModificarEmpleado (var empleados: archivo_empleados);
var
	num: integer; no_esta: boolean; emple: reg_empleados;
begin
	reset (empleados);
	no_esta:= True;
	writeln('Ingrese un numero de empleado: ');
	readln(num);
	while not EOF(empleados) and no_esta do begin
		read(empleados, emple);
		if (emple.numero = num) then no_esta:= False;
	end;
	if no_esta then writeln('El empleado no fue encontrado.')
	else begin
		seek (empleados, filePos(empleados)-1);
		read(empleados, emple);
		writeln('Ingrese la edad correcta: ');
		readln(emple.edad);
		seek (empleados, filePos(empleados)-1);
		write(empleados, emple);
		writeln;
		writeln('Correcion aplicada.');
		writeln;
	end; 

	close(empleados);
end;

procedure ExportarTexto (var empleados: archivo_empleados);
var
	empleados_texto: text; emple: reg_empleados;
begin
	assign(empleados_texto, 'todos_empleados.txt');
	reset(empleados);
	rewrite(empleados_texto);
	
	while not EOF(empleados) do begin
		read(empleados, emple);
		writeln(empleados_texto, emple.numero, ' ', emple.edad, ' ', emple.DNI, ' ', emple.apellido);
		writeln(empleados_texto, emple.nombre);
	end;
	
	writeln ('Exportado con exito.');
	writeln;
	close(empleados);
	close(empleados_texto);
end;

procedure SinDNI (var empleados: archivo_empleados);
var
	empleados_texto: text; emple: reg_empleados;
begin
	assign(empleados_texto, 'faltaDNIEmpleado.txt');
	reset(empleados);
	rewrite(empleados_texto);
	
	while not EOF(empleados) do begin
		read(empleados, emple);
		if (emple.DNI = 00) then begin
			writeln(empleados_texto, emple.numero, ' ', emple.edad, ' ', emple.DNI, ' ', emple.apellido);
			writeln(empleados_texto, emple.nombre);
		end;
	end;
	
	writeln ('Exportado con exito.');
	writeln;
	close(empleados);
	close(empleados_texto);
end;

var
	empleados: archivo_empleados;
	nombre_fisico: string;
	opcion: integer;
	
BEGIN
	repeat
		writeln('--------- MENU ---------');
		writeln('1. Crear archivo.');
		writeln('2. Abrir archivo.');
		writeln('3. Agregar empleados.');
		writeln('4. Modificar empleado.');
		writeln('5. Exportar a archivo de texto.');
		writeln('6. Exportar a texto los empleados sin DNI cargado.');
		writeln('7. Cerrar menu.');
		readln(opcion);
		if (opcion = 1) or (opcion = 2) or (opcion = 3) or (opcion = 4) or (opcion = 5) or (opcion = 6) then begin
			write('Ingrese el nombre del archivo: ');
			readln(nombre_fisico);
			assign(empleados, nombre_fisico);
		end;
		case opcion of
			1: CrearArchivo (empleados);
			2: AbrirArchivo (empleados);
			3: AgregarEmpleados (empleados);
			4: ModificarEmpleado (empleados);
			5: ExportarTexto (empleados);
			6: SinDNI (empleados);
			7: write(#10, 'Cerrando...');
		else write('El numero ingresado no corresponde con ninguna opcion. Intenta de nuevo.', #10);
		end;
	until opcion = 7
END.
