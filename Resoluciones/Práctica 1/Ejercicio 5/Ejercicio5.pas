{ 5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”
}


program Ejercicio5;

type
	reg_celular = record
		codigo: integer;
		precio: integer;
		marca: string;
		stock_disp: integer;
		stock_min: integer;
		descripcion: string;
		nombre: string;
	end;
	
	archivo_celulares = file of reg_celular;

procedure ImprimirCelu (celu: reg_celular);
begin
	writeln('Codigo: ', celu.codigo);
	writeln('Precio: ', celu.precio);
	writeln('Marca: ', celu.marca);
	writeln('Stock disponible: ', celu.stock_disp);
	writeln('Stock minimo: ', celu.stock_min);
	writeln('Descripcion: ', celu.descripcion);
	writeln('Nombre: ', celu.nombre);
	writeln;
end;

procedure CrearArchivo (var celulares: archivo_celulares);
var
	txt: text; celu: reg_celular;
begin
	assign(txt, 'celulares.txt');
	reset(txt);
	rewrite(celulares);
	writeln;
	writeln('Cargando datos desde "celulares.txt"...');
	while not EOF(txt) do begin
		readln(txt, celu.codigo, celu.precio, celu.marca);
		readln(txt, celu.stock_disp, celu.stock_min, celu.descripcion);
		readln(txt, celu.nombre);
		write(celulares, celu);
	end;
	writeln;
	writeln('Carga finalizada con exito.');
	writeln;
	
	close(txt);
	close(celulares);
end;

procedure StockCritico (var celulares: archivo_celulares);
var
	celu: reg_celular;
begin
	reset(celulares);
	
	writeln;
	writeln('---------- STOCK CRITICO ----------');
	writeln;
	while not EOF(celulares) do begin
		read(celulares, celu);
		if celu.stock_disp < celu.stock_min then ImprimirCelu(celu);
	end;
	
	close(celulares);
end;

procedure BusquedaPorDescripcion (var celulares: archivo_celulares);
var
	desc: string; celu: reg_celular;
begin
	reset(celulares);
	
	writeln;
	writeln('Ingrese descripcion a buscar: ');
	readln(desc);
	writeln;
	
	writeln('---------- RESULTADOS ----------');
	writeln;
	while not EOF(celulares) do begin
		read(celulares, celu);
		if (pos(desc, celu.descripcion)<>0) then ImprimirCelu(celu);
	end;
	
	close(celulares);
end;

procedure ExportarTexto (var celulares: archivo_celulares);
var
	txt: text; celu: reg_celular;
begin
	assign(txt, 'celulares.txt');
	reset(celulares);
	rewrite(txt);
	
	writeln('Cargando datos a "celulares.txt"...');
	while not EOF(celulares) do begin
		read(celulares, celu);
		writeln(txt, celu.codigo, ' ', celu.precio, ' ', celu.marca);
		writeln(txt, celu.stock_disp, ' ', celu.stock_min, ' ', celu.descripcion);
		writeln(txt, celu.nombre);
	end;
	writeln;
	writeln('Carga finalizada con exito.');
	writeln;
	
	close(celulares);
	close(txt);
end;

var
	celulares: archivo_celulares; opcion: integer; nom_fisico: string;

BEGIN
	repeat
		writeln('---------- MENU ----------');
		writeln('1. Crear archivo.');
		writeln('2. Ver celulares con stock menor al stock minimo.');
		writeln('3. Buscar por descripcion.');
		writeln('4. Exportar contenido a texto.');
		writeln('5. Salir.');
		readln(opcion);
		if (opcion = 1) or (opcion = 2) or (opcion = 3) or (opcion = 4) then begin
			writeln('Ingrese el nombre del archivo: ');
			readln(nom_fisico);
			assign(celulares, nom_fisico);
		end;
		case opcion of
			1: CrearArchivo(celulares);
			2: StockCritico(celulares);
			3: BusquedaPorDescripcion(celulares);
			4: ExportarTexto(celulares);
			5: writeln('Cerrando programa...');
		else writeln('Opcion no valida. Intente de nuevo.');
		end;
	until opcion = 5;
END.

