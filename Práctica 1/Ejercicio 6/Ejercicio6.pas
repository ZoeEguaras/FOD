{ 6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.
}

program Ejercicio6;

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

procedure CargarCelu (var celu: reg_celular);
begin
	writeln('Ingrese codigo: ');
	readln(celu.codigo);
	writeln('Ingrese precio: ');
	readln(celu.precio);
	writeln('Ingrese marca: ');
	readln(celu.marca);
	writeln('Ingrese stock disponible: ');
	readln(celu.stock_disp);
	writeln('Ingrese stock minimo: ');
	readln(celu.stock_min);
	writeln('Ingrese descripcion: ');
	readln(celu.descripcion);
	writeln('Ingrese nombre: ');
	readln(celu.nombre);
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

procedure AgregarCelulares (var celulares: archivo_celulares);
var
	celu, nuevo: reg_celular; existe: boolean; opcion: integer;
begin
	reset(celulares);
	
	repeat
		writeln;
		seek(celulares, 0);
		writeln('---------- NUEVO CELULAR ----------');
		CargarCelu(nuevo);
		existe:= false;
		while (not EOF(celulares) and not existe) do begin
			read(celulares, celu);
			if (celu.nombre = nuevo.nombre) then existe:= true;
		end;
		if (existe) then begin
			writeln('El celular ingresado ya existe.');
			writeln;
		end
		else write(celulares, nuevo);
		writeln('Si desea finalizar la carga ingrese 0, de lo contrario ingrese 1.');
		readln(opcion);
	until opcion = 0;
	
	writeln;
	writeln('Carga finalizada con exito.');
	writeln;
	close(celulares);
end;

procedure ModificarStock (var celulares: archivo_celulares);
var
	nom: string; celu: reg_celular; encontre: boolean; stock: integer;
begin
	reset(celulares);
	
	writeln('Ingrese el nombre del celular a modificar: ');
	readln(nom);
	encontre:= false;
	while not EOF(celulares) and not encontre do begin
		read(celulares, celu);
		if celu.nombre = nom then encontre:= true;
	end;
	if encontre then begin
		seek(celulares, filepos(celulares)-1);
		write('Ingrese el nuevo stock disponible: ');
		readln(stock);
		celu.stock_disp:= stock;
		write(celulares, celu);
		writeln;
		writeln('Stock modificado con exito.');
	end
	else begin
		writeln;
		writeln('Celular no encontrado.');
	end;
	
	writeln;
	close(celulares);
end;

procedure ExportarSinStock (var celulares: archivo_celulares);
var
	txt: text; celu: reg_celular;
begin
	writeln;
	writeln('Exportando celulares sin stock a "SinStock.txt"...');
	writeln;
	
	assign(txt, 'SinStock.txt');
	reset(celulares);
	rewrite(txt);
	while not EOF(celulares) do begin
		read(celulares, celu);
		if (celu.stock_disp = 0) then begin
			writeln(txt, celu.codigo, ' ', celu.precio, ' ', celu.marca);
			writeln(txt, celu.stock_disp, ' ', celu.stock_min, ' ', celu.descripcion);
			writeln(txt, celu.nombre);
		end;
	end;
	
	writeln('Carga finalizada.');
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
		writeln('5. Agregar celulares.');
		writeln('6. Modificar stock.');
		writeln('7. Exportar celulares sin stock a texto.');
		writeln('8. Salir.');
		readln(opcion);
		if (opcion = 1) or (opcion = 2) or (opcion = 3) or (opcion = 4) or (opcion = 5) or (opcion = 6) or (opcion = 7) then begin
			writeln('Ingrese el nombre del archivo: ');
			readln(nom_fisico);
			assign(celulares, nom_fisico);
		end;
		case opcion of
			1: CrearArchivo(celulares);
			2: StockCritico(celulares);
			3: BusquedaPorDescripcion(celulares);
			4: ExportarTexto(celulares);
			5: AgregarCelulares(celulares);
			6: ModificarStock(celulares);
			7: ExportarSinStock(celulares);
			8: writeln(#10, 'Cerrando programa...');
		else writeln('Opcion no valida. Intente de nuevo.');
		end;
	until opcion = 8;
END.

