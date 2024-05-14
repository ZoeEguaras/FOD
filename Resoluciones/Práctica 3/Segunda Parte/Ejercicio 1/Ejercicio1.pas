{1. El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:

a. Se pide realizar un procedimiento que actualice el archivo maestro con el archivo detalle, teniendo en cuenta que:
i.  Los archivos no están ordenados por ningún criterio.
ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.

b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?
}


program Ejercicio1;

const
	valor_alto = 9999;

type
	reg_producto = record
		codigo: integer;
		nombre: string;
		precio: real;
		stock_actual: integer;
		stock_minimo: integer;
	end;
	
	reg_venta = record
		codigo: integer;
		unidades: integer;
	end;
	
	archivo_maestro = file of reg_producto;
	archivo_detalle = file of reg_venta;
	
procedure leerVenta (var detalle: archivo_detalle; var venta: reg_venta);
begin
	if not EOF(detalle) then read(detalle, venta)
	else venta.codigo:= valor_alto;
end;

procedure cargarMaestro (var maestro: archivo_maestro);
var
	producto: reg_producto;
	
begin
	rewrite(maestro);
	
	writeln(#10, 'CARGANDO ARCHIVO...');

	producto.codigo := 45;
    producto.nombre := 'Leche';
    producto.precio := 1800.50;
    producto.stock_actual := 1800;
    producto.stock_minimo := 100;
    write(maestro, producto);
    
    producto.codigo := 23;
	producto.nombre := 'Pan Blanco';
	producto.precio := 900.25;
	producto.stock_actual := 950;
	producto.stock_minimo := 200;
	write(maestro, producto);

	producto.codigo := 56;
	producto.nombre := 'Queso Cheddar';
	producto.precio := 1200.75;
	producto.stock_actual := 1100;
	producto.stock_minimo := 300;
	write(maestro, producto);

	producto.codigo := 67;
	producto.nombre := 'Yogur de Vainilla';
	producto.precio := 700.50;
	producto.stock_actual := 750;
	producto.stock_minimo := 150;
	write(maestro, producto);

	producto.codigo := 34;
	producto.nombre := 'Papas Fritas';
	producto.precio := 850.00;
	producto.stock_actual := 900;
	producto.stock_minimo := 200;
	write(maestro, producto);

	producto.codigo := 21;
	producto.nombre := 'Tomates Frescos';
	producto.precio := 650.25;
	producto.stock_actual := 1200;
	producto.stock_minimo := 300;
	write(maestro, producto);

	producto.codigo := 78;
	producto.nombre := 'Huevos Blancos';
	producto.precio := 400.00;
	producto.stock_actual := 600;
	producto.stock_minimo := 150;
	write(maestro, producto);
	
	writeln(#10, 'Carga finalizada con exito.');
	close(maestro);
end;


// Y a vos que te estas copiando los constructores, vos acordate nomás, en mi época los teníamos que hacer a mano
// (Los hizo chatGPT)
procedure cargarDetalle (var detalle: archivo_detalle);
var
	venta: reg_venta;
	
begin
	rewrite(detalle);
	
	venta.codigo := 34;
	venta.unidades := 12;
	write(detalle, venta);

	venta.codigo := 67;
	venta.unidades := 28;
	write(detalle, venta);

	venta.codigo := 78;
	venta.unidades := 45;
	write(detalle, venta);

	venta.codigo := 23;
	venta.unidades := 30;
	write(detalle, venta);

	venta.codigo := 45;
	venta.unidades := 400;
	write(detalle, venta);

	venta.codigo := 56;
	venta.unidades := 4;
	write(detalle, venta);

	venta.codigo := 23;
	venta.unidades := 20;
	write(detalle, venta);

	venta.codigo := 67;
	venta.unidades := 100;
	write(detalle, venta);

	venta.codigo := 45;
	venta.unidades := 400;
	write(detalle, venta);

	venta.codigo := 56;
	venta.unidades := 46;
	write(detalle, venta);

	venta.codigo := 34;
	venta.unidades := 25;
	write(detalle, venta);

	venta.codigo := 67;
	venta.unidades := 34;
	write(detalle, venta);

	venta.codigo := 23;
	venta.unidades := 11;
	write(detalle, venta);

	venta.codigo := 78;
	venta.unidades := 2;
	write(detalle, venta);

	venta.codigo := 56;
	venta.unidades := 29;
	write(detalle, venta);

	venta.codigo := 34;
	venta.unidades := 36;
	write(detalle, venta);

	venta.codigo := 67;
	venta.unidades := 32;
	write(detalle, venta);

	venta.codigo := 23;
	venta.unidades := 16;
	write(detalle, venta);
		
	close(detalle);
end;

procedure imprimirProducto (producto: reg_producto);
begin
	writeln('Codigo: ', producto.codigo);
	writeln('Nombre: ', producto.nombre);
	writeln('Precio: ', producto.precio:6:3);
	writeln('Stock actual: ', producto.stock_actual);
	writeln('Stock minimo: ', producto.stock_minimo);
	writeln;
end;

procedure imprimirMaestro (var maestro: archivo_maestro);
var
	producto: reg_producto;
	
begin
	reset(maestro);
	
	writeln(#10, '------------ PRODUCTOS ------------');
	while not EOF(maestro) do begin
		read(maestro, producto);
		imprimirProducto(producto);
	end;
	
	close(maestro);
end;

procedure actualizarMaestro (var maestro: archivo_maestro; var detalle: archivo_detalle);
var
	venta: reg_venta; producto: reg_producto; total: integer;
	
begin
	reset(maestro);
	
	writeln(#10, 'ACTUALIZANDO...');
	while not EOF(maestro) do begin
		read(maestro, producto);
		total:= 0;
		reset(detalle);
		leerVenta(detalle, venta);
		while (venta.codigo <> valor_alto) do begin
			if (venta.codigo = producto.codigo) then total:= total + venta.unidades;
			leerVenta(detalle, venta);
		end;
		close(detalle);
		producto.stock_actual:= producto.stock_actual - total;
		seek(maestro, filePos(maestro) - 1);
		write(maestro, producto);
	end;
	writeln(#10, 'Archivo Maestro actualizado con exito');	
	
	close(maestro);
end;


var
	maestro: archivo_maestro; detalle: archivo_detalle;

BEGIN
	assign(maestro, 'Archivo Maestro');
	assign(detalle, 'Archivo Detalle');
	// Los creo para probar
	cargarMaestro(maestro);
	cargarDetalle(detalle);
	
	// Chequeo
	imprimirMaestro(maestro);
	
	// Actualizo
	actualizarMaestro(maestro, detalle);
	
	// Chequeo
	imprimirMaestro(maestro);
END.

