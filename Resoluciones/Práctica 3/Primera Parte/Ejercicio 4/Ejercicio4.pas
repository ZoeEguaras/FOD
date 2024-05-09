{4. Dada la siguiente estructura:
	type
		reg_flor = record
			nombre: String[45];
			codigo:integer;
		end;
		tArchFlores = file of reg_flor;

 Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

 a. Implemente el siguiente módulo:
(Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente)
procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);

 b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.
}


program Ejercicio4;

type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	
	tArchFlores = file of reg_flor;

procedure leerFlor (var flor: reg_flor);
begin
	write(#10, 'Ingrese nombre: ');
	readln(flor.nombre);
	write('Ingrese codigo: ');
	readln(flor.codigo);
end;

procedure imprimirFlor (flor: reg_flor);
begin
	writeln('Nombre: ', flor.nombre);
	writeln('Codigo: ', flor.codigo);
	writeln;
end;

procedure asignarNombre (var archivo: tArchFlores);
var
	nombre_fisico: string;
	
begin
	writeln(#10, 'Ingrese el nombre del archivo: ');
	readln(nombre_fisico);
	assign(archivo, nombre_fisico);
end;

procedure cargarArchivo (var archivo: tArchFlores);
var
	flor: reg_flor;
	
begin
	rewrite(archivo);
	
	flor.codigo:= 0;
	write(archivo, flor);
	writeln(#10, 'CARGANDO ARCHIVO...');
	writeln('- Ingrese el codigo -1 para finalizar.', #10);
	leerFlor(flor);
	while (flor.codigo <> -1) do begin
		write(archivo, flor);
		leerFlor(flor);
	end;
	
	writeln(#10, 'Carga finalizada con exito.');
	close(archivo);
end;

procedure agregarFlor (var a: tArchFlores; nombre: string; codigo: integer);
var
	flor, espacio: reg_flor;

begin
	reset(a);
	
	flor.nombre:= nombre;
	flor.codigo:= codigo;
	read(a, espacio);
	if (espacio.codigo = 0) then begin
		seek(a, fileSize(a));
		write(a, flor);
	end
	else begin
		seek(a, espacio.codigo * -1);
		read(a, espacio);
		seek(a, filePos(a) - 1);
		write(a, flor);
		seek(a, 0);
		write(a, espacio);
	end;
	writeln(#10, 'Flor agregada con exito.');
	
	close(a);
end;

procedure listarFlores (var a: tArchFlores);
var
	flor: reg_flor;
	
begin
	reset(a);
	
	writeln(#10, '--------- FLORES ---------');
	while not EOF(a) do begin
		read(a, flor);
		if (flor.codigo > 0) then imprimirFlor(flor);
	end;
	
	close(a);
end;


var
	archivo: tArchFlores; opcion, codigo: integer; nombre: string[45];
	
BEGIN
	// Lo asigno acá arriba así ya trabajo siempre con el mismo
	asignarNombre(archivo);
	
	// Me arme el menú para poder probar cada cosa por separado
	repeat
		writeln(#10, '-------- MENU --------');
		writeln('1. Crear archivo.');
		writeln('2. Agregar flor.');
		writeln('3. Listar flores.');
		writeln('4. Salir.');
		readln(opcion);
		case opcion of
			1: cargarArchivo(archivo);
			2: begin
				write(#10, 'Ingrese nombre: ');
				readln(nombre);
				write('Ingrese codigo: ');
				readln(codigo);
				agregarFlor(archivo, nombre, codigo);
			end;
			3: listarFlores(archivo);
			4: writeln(#10, 'Cerrando aplicacion...');
		else writeln(#10, 'Opcion invalida. Por favor intente de nuevo.');
		end;
	until opcion = 4;
END.

