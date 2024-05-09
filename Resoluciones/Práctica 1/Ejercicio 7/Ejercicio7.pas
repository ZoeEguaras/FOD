{  Realizar un programa que permita:
 a) Crear un archivo binario a partir de la información almacenada en un archivo de
 texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
 archivo de texto consiste en: código de novela, nombre, género y precio de
 diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
 líneas en el archivo de texto. La primera línea contendrá la siguiente información:
 código novela, precio y género, y la segunda línea almacenará el nombre de la
 novela.
 b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
 agregar una novela y modificar una existente. Las búsquedas se realizan por
 código de novela.
 NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.
}


program Ejercicio7;

type
	reg_novelas = record
		codigo: integer;
		precio: real;
		genero: string;
		nombre: string;
	end;
	
	archivo_novelas = file of reg_novelas;
	
procedure CrearArchivo (var novelas: archivo_novelas);
var
	txt: text; nov: reg_novelas;
begin
	assign(txt, 'novelas.txt');
	rewrite(novelas);
	reset(txt);
	writeln('Cargando datos de "novelas.txt"...');
	while not EOF(txt) do begin
		readln(txt, nov.codigo, nov.precio, nov.genero);
		readln(txt, nov.nombre);
		write(novelas, nov);
	end;
	
	writeln;
	writeln('Carga finalizada con exito');
	writeln;
	
	close(novelas);
	close(txt);
end;

procedure LeerNovela (var nov: reg_novelas);
begin
	writeln('Ingrese codigo: ');
	readln(nov.codigo);
	writeln('Ingrese precio: ');
	readln(nov.precio);
	writeln('Ingrese genero: ');
	readln(nov.genero);
	writeln('Ingrese nombre: ');
	readln(nov.nombre);
	writeln;
end;

procedure AbrirArchivo (var novelas: archivo_novelas);
	procedure AgregarNovela (var novelas: archivo_novelas);
	var
		nueva, nov: reg_novelas; existe: boolean;
	begin
		reset(novelas);
		
		writeln;
		writeln('---------- NUEVA NOVELA ----------');
		LeerNovela(nueva);
		existe:= false;
		while not EOF(novelas) and not existe do begin
			read(novelas, nov);
			if (nov.codigo = nueva.codigo) then existe:= true;
		end;
		if existe then writeln('La novela ya esta cargada.', #10)
		else begin
			write(novelas, nueva);
			writeln('La novela ha sido cargada con exito.', #10);
		end;
		
		close(novelas);
	end;
	
	procedure ModificarNovela (var novelas: archivo_novelas);
	var
		cod, opcion:integer; encontre: boolean; dato_real: real; dato_str: string; nov: reg_novelas;
	begin
		reset(novelas);
		
		writeln;
		writeln('Ingrese el codigo de la novela a modificar: ');
		readln(cod);
		encontre:= false;
		while not EOF(novelas) and not encontre do begin
			read(novelas, nov);
			if (nov.codigo = cod) then encontre:= true;
		end;
		if encontre then begin
			seek(novelas, filepos(novelas)-1);
			repeat
				writeln('Que desea modificar?');
				writeln('1. Precio.');
				writeln('2. Genero.');
				writeln('3. Nombre.');
				writeln('4. Finalizar.');
				readln(opcion);
				case opcion of
					1: begin
						writeln('Ingrese el nuevo precio: ');
						readln(dato_real);
						nov.precio:= dato_real;
						writeln;
					end;
					2: begin
						writeln('Ingrese el nuevo genero: ');
						readln(dato_str);
						nov.genero:= dato_str;
						writeln;
					end;
					3: begin
						writeln('Ingrese el nuevo nombre: ');
						readln(dato_str);
						nov.nombre:= dato_str;
						writeln;
					end;
					4: begin
						write(novelas, nov);
						writeln(#10, 'Modificaciones aplicadas con exito.', #10);
					end;
				else writeln('Opcion invalida. Intente de nuevo.', #10);
				end;		
			until opcion = 4;
		end
		else writeln('La novela ', cod, ' no existe o no ha sido cargada.', #10); 
		
		close(novelas);
	end;
	
var
	opcion: integer; 
begin
	repeat
		writeln('Seleccione la opcion deseada:');
		writeln('1. Agregar novela.');
		writeln('2. Modificar novela.');
		writeln('3. Volver.');
		readln(opcion);
		
		case opcion of
			1: AgregarNovela(novelas);
			2: ModificarNovela(novelas);
			3: writeln(#10, 'Regresando al menu...', #10);
		else writeln('Opcion invalida. Intente de nuevo.', #10);
		end;
	until opcion = 3;
end;

procedure ExportarTexto (var novelas: archivo_novelas);
var
	txt: text; nov: reg_novelas;
begin
	assign(txt, 'novelas.txt');
	reset(novelas);
	rewrite(txt);
	writeln('Exportando a "novelas.txt"...');
	while not EOF(novelas) do begin
		read(novelas, nov);
		writeln(txt, nov.codigo, ' ', nov.precio:5:2, ' ', nov.genero);
		writeln(txt, nov.nombre);
	end;
	writeln;
	writeln('Carga completada con exito.');
	writeln;
	
	close(novelas);
	close(txt);
end;

var
	novelas: archivo_novelas; nombre_fisico: string; opcion: integer;

BEGIN
	repeat
		writeln('---------- MENU ----------');
		writeln('1. Crear archivo.');
		writeln('2. Abrir archivo.');
		writeln('3. Exportar a texto.');
		writeln('4. Cerrar aplicacion.');
		readln(opcion);
		writeln;
		if (opcion >= 1) and (opcion <= 3) then begin
			writeln('Ingrese el nombre del archivo: ');
			readln(nombre_fisico);
			writeln;
			assign(novelas, nombre_fisico);
		end;
		
		case opcion of
			1: CrearArchivo(novelas);
			2: AbrirArchivo(novelas);
			3: ExportarTexto(novelas);
			4: writeln('Cerrando...');
		else writeln('Opcion invalida. Intente de nuevo.', #10);
		end;
	until opcion = 4;
END.
