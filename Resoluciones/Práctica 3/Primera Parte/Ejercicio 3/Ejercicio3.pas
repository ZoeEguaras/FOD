{ 3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.

b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.

c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
 
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.
}


program Ejercicio3;

type
	reg_novela = record
		codigo: integer;
		genero: string[20];
		nombre: string[40];
		duracion: real;
		director: string[40];
		precio: real;
	end;
	
	archivo_novelas = file of reg_novela;
	
procedure leerNovela (var novela: reg_novela);
begin
	write('Ingrese codigo: ');
	readln(novela.codigo);
	write('Ingrese genero: ');
	readln(novela.genero);
	write('Ingrese nombre: ');
	readln(novela.nombre);
	write('Ingrese duracion: ');
	readln(novela.duracion);
	write('Ingrese director: ');
	readln(novela.director);
	write('Ingrese precio: ');
	readln(novela.precio);
	writeln;
end;

procedure imprimirNovela (novela: reg_novela);
begin
	writeln('Codigo: ', novela.codigo);
	writeln('Genero: ', novela.genero);
	writeln('Nombre: ', novela.nombre);
	writeln('Duracion: ', novela.duracion:3:2);
	writeln('Director: ', novela.director);
	writeln('Precio: ', novela.precio:5:2);
	writeln;
end;

procedure asignarNombre (var archivo: archivo_novelas);
var
	nombre_fisico: string;
	
begin
	writeln(#10, 'Ingrese el nombre del archivo: ');
	readln(nombre_fisico);
	assign(archivo, nombre_fisico);
end;

procedure cargarArchivo (var archivo: archivo_novelas);
var
	novela: reg_novela;
	
begin
	asignarNombre(archivo);
	rewrite(archivo);
	
	novela.codigo:= 0;
	write(archivo, novela);
	writeln(#10, 'CARGANDO ARCHIVO...');
	writeln('- Ingrese el codigo -1 para finalizar.', #10);
	leerNovela(novela);
	while (novela.codigo <> -1) do begin
		write(archivo, novela);
		leerNovela(novela);
	end;
	
	writeln(#10, 'Carga finalizada con exito.');
	close(archivo);
end;

procedure agregarNovela (var archivo: archivo_novelas);
var
	novela, espacio: reg_novela;
	
begin
	reset(archivo);
	
	writeln(#10, 'Datos de la nueva novela: ');
	leerNovela(novela);
	read(archivo, espacio);
	if (espacio.codigo = 0) then begin
		seek(archivo, fileSize(archivo));
		write(archivo, novela);
	end
	else begin
		seek(archivo, espacio.codigo * -1);
		read(archivo, espacio);
		seek(archivo, filePos(archivo) - 1);
		write(archivo, novela);
		seek(archivo, 0);
		write(archivo, espacio);
	end;
	writeln(#10, 'Novela agregada con exito.');
	
	close(archivo);
end;

procedure modificarNovela (var archivo: archivo_novelas);
var
	novela: reg_novela; codigo: integer;
	
begin
	reset(archivo);
	
	writeln(#10, 'Ingrese el codigo de la novela a modificar: ');
	readln(codigo);
	read(archivo, novela);
	while not EOF(archivo) and (novela.codigo <> codigo) do begin
		read(archivo, novela);
	end;
	if (novela.codigo = codigo) then begin
		writeln(#10, 'Datos de la novela:');
		imprimirNovela(novela);
		writeln(#10, 'Nuevos datos: ');
		write('Ingrese genero: ');
		readln(novela.genero);
		write('Ingrese nombre: ');
		readln(novela.nombre);
		write('Ingrese duracion: ');
		readln(novela.duracion);
		write('Ingrese director: ');
		readln(novela.director);
		write('Ingrese precio: ');
		readln(novela.precio);
		seek(archivo, filePos(archivo) - 1);
		write(archivo, novela);
		writeln(#10, 'Datos modificados con exito.');
	end
	else writeln(#10, 'Novela ', codigo, ' no encontrada.');
	
	close(archivo);
end;

procedure eliminarNovela (var archivo: archivo_novelas);
var
	novela, cabecera: reg_novela; codigo, pos: integer;
	
begin
	reset(archivo);
	
	writeln(#10, 'Ingrese el codigo de la novela a eliminar: ');
	readln(codigo);
	
	read(archivo, cabecera);
	read(archivo, novela);
	while not EOF(archivo) and (novela.codigo <> codigo) do begin
		read(archivo, novela);
	end;
	if (novela.codigo = codigo) then begin
		pos:= filePos(archivo) - 1;
		novela.codigo:= pos * -1;
		seek(archivo, pos);
		write(archivo, cabecera);
		seek(archivo, 0);
		write(archivo, novela);
		writeln(#10, 'Novela ', codigo, ' eliminada con exito.');
	end
	else writeln(#10, 'Novela ', codigo, ' no encontrada.');
	
	close(archivo);
end;

procedure aperturaMenu (var archivo: archivo_novelas);
var
	opcion: integer;
	
begin
	asignarNombre(archivo);
	repeat
		writeln(#10, 'Seleccione la opcion deseada:');
		writeln('1. Agregar una nueva novela.');
		writeln('2. Modificar una novela.');
		writeln('3. Eliminar una novela.');
		writeln('4. Salir.');
		readln(opcion);
		case opcion of
			1: agregarNovela(archivo);
			2: modificarNovela(archivo);
			3: eliminarNovela(archivo);
			4: writeln(#10, 'Cerrando menu...');
		else writeln(#10, 'Opcion invalida. Por favor intente de nuevo.');
		end;	
	until opcion = 4; 
end;

procedure listarArchivo (var archivo: archivo_novelas);
var
	novela: reg_novela;
	
begin
	asignarNombre(archivo);
	reset(archivo);
	
	writeln(#10, '--------- CONTENIDO ---------');
	while not EOF(archivo) do begin
		read(archivo, novela);
		if (novela.codigo > 0) then begin
			writeln('- Novela.');
			imprimirNovela(novela);
		end
		else begin
			writeln('- Espacio Libre.');
			writeln('Enlace: ', novela.codigo, #10);
		end;
	end;
	
	close(archivo);
end;


var
	archivo: archivo_novelas; opcion: integer;
	
BEGIN
	repeat
		writeln(#10, '-------- MENU --------');
		writeln('1. Crear archivo.');
		writeln('2. Abrir archivo.');
		writeln('3. Listar archivo.');
		writeln('4. Salir.');
		readln(opcion);
		case opcion of
			1: cargarArchivo(archivo);
			2: aperturaMenu(archivo);
			3: listarArchivo(archivo);
			4: writeln(#10, 'Cerrando aplicacion...');
		else writeln(#10, 'Opcion invalida. Por favor intente de nuevo.');
		end;
	until opcion = 4;
END.

