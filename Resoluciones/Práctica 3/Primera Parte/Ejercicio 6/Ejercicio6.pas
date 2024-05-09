{ 6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
 
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.
}


program Ejercicio6;

const
	valor_alto = 9999;

type
	reg_prenda = record
		codigo: integer;
		descripcion: string;
		colores: string;
		tipo: string;
		stock: integer;
		precio: real;
	end;
	
	archivo_maestro = file of reg_prenda;
	archivo_detalle = file of integer;
	
procedure leerCodigo (var archivo: archivo_detalle; var codigo: integer);
begin
	if not EOF(archivo) then read(archivo, codigo)
	else codigo:= valor_alto;
end;

procedure leerPrenda (var archivo: archivo_maestro; var prenda: reg_prenda);
begin
	if not EOF(archivo) then read(archivo, prenda)
	else prenda.codigo:= valor_alto;
end;

procedure crearMaestro (var maestro: archivo_maestro);
var
	prenda: reg_prenda;
	
begin
	rewrite(maestro);
	
	// Prenda 1
    prenda.codigo:= 2;
    prenda.descripcion:= 'Tela de algodon y poliester.';
    prenda.colores:= 'Rojo y negro';
    prenda.tipo:= 'Remera';
    prenda.stock:= 120;
    prenda.precio:= 12500.50;
    write(maestro, prenda);
    
    // Prenda 2
    prenda.codigo:= 9;
    prenda.descripcion:= 'Mezclilla.';
    prenda.colores:= 'Azul';
    prenda.tipo:= 'Jeans';
    prenda.stock:= 80;
    prenda.precio:= 29999.99;
    write(maestro, prenda);
    
    // Prenda 3
    prenda.codigo:= 4;
    prenda.descripcion:= 'Poliester.';
    prenda.colores:= 'Blanco';
    prenda.tipo:= 'Camisa';
    prenda.stock:= 50;
    prenda.precio:= 18999.75;
    write(maestro, prenda);
    
    // Prenda 4
    prenda.codigo:= 3;
    prenda.descripcion:= 'Algodon.';
    prenda.colores:= 'Negro y blanco';
    prenda.tipo:= 'Pantalon deportivo';
    prenda.stock:= 100;
    prenda.precio:= 15999.00;
    write(maestro, prenda);
    
    // Prenda 5
    prenda.codigo:= 5;
    prenda.descripcion:= 'Con manga y de lana.';
    prenda.colores:= 'Gris';
    prenda.tipo:= 'Sueter';
    prenda.stock:= 60;
    prenda.precio:= 23999.50;
    write(maestro, prenda);
	
	close(maestro);
end;

procedure crearDetalle (var detalle: archivo_detalle);
var
	codigo: integer;
	
begin
	rewrite(detalle);
    
    // Prenda 2
    codigo:= 2;
    write(detalle, codigo);
    
    // Prenda 3
    codigo:= 3;
    write(detalle, codigo);
    
    // Prenda 5
    codigo:= 5;
    write(detalle, codigo);
	
	close(detalle);
end;

procedure imprimirPrenda (prenda: reg_prenda);
begin
	writeln('Codigo: ', prenda.codigo);
	writeln('Descripcion: ', prenda.descripcion);
	writeln('Colores: ', prenda.colores);
	writeln('Tipo: ', prenda.tipo);
	writeln('Stock: ', prenda.stock);
	writeln('Precio: ', prenda.precio:6:2);
	writeln;
end;

procedure imprimirMaestro (var maestro: archivo_maestro);
var
	prenda: reg_prenda;
	
begin
	reset(maestro);

	leerPrenda(maestro, prenda);
	while (prenda.codigo <> valor_alto) do begin
		writeln(#10, '- Prenda');
		imprimirPrenda(prenda);
		leerPrenda(maestro, prenda);
	end;

	close(maestro);
end;

procedure imprimirDetalle (var detalle: archivo_detalle);
var
	codigo: integer;
	
begin
	reset(detalle);

	leerCodigo(detalle, codigo);
	while (codigo <> valor_alto) do begin
		writeln(#10, 'Codigo: ', codigo);
		leerCodigo(detalle, codigo);
	end;

	close(detalle);
end;

procedure actualizarMaestro (var maestro: archivo_maestro; var detalle: archivo_detalle);
var
	prenda: reg_prenda; codigo: integer;
	
begin
	reset(detalle);
	reset(maestro);
	
	leerCodigo(detalle, codigo);
	while (codigo <> valor_alto) do begin
		seek(maestro, 0);
		read(maestro, prenda);
		while not EOF(maestro) and (prenda.codigo <> codigo) do begin
			read(maestro, prenda);
		end;
		if (prenda.codigo = codigo) then begin
			prenda.stock:= prenda.stock * -1;
			seek(maestro, filePos(maestro) - 1);
			write(maestro, prenda);
		end;
		leerCodigo(detalle, codigo);
	end;
	
	close(detalle);
	close(maestro);
end;

procedure compactarMaestro (var maestro: archivo_maestro);
var
	prenda: reg_prenda; copia: archivo_maestro;
	
begin
	assign(copia, 'Copia Prendas');
	rewrite(copia);
	reset(maestro);
	
	leerPrenda(maestro, prenda);
	while (prenda.codigo <> valor_alto) do begin
		if prenda.stock >= 0 then write(copia, prenda);
		leerPrenda(maestro, prenda);
	end;
	
	close(maestro);
	close(copia);
	
	erase(maestro);
    rename(copia, 'Maestro Prendas');
end;


var
	maestro: archivo_maestro; detalle: archivo_detalle;

BEGIN
	assign(maestro, 'Maestro Prendas');
	assign(detalle, 'Detalle Prendas');
	
	// Creo los archivos para probar el programa y los imprimo
	crearMaestro(maestro);
	crearDetalle(detalle);
	writeln(#10, '------------ PRENDAS INICIALES ------------');
	imprimirMaestro(maestro);
	writeln(#10, '------------ CODIGOS A ELIMINAR ------------');
	imprimirDetalle(detalle);
	
	// Actualizo el maestro e imprimo los resultados
	actualizarMaestro(maestro, detalle);
	writeln(#10, '------------ MAESTRO ACTUALIZADO ------------');
	imprimirMaestro(maestro);
	
	// Compacto e imprimo la copia
	compactarMaestro(maestro);
	writeln(#10, '------------ NUEVA COPIA ------------');
	imprimirMaestro(maestro);
END.

