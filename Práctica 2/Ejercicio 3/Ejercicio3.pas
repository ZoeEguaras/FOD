{ 3. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
}


program Ejercicio3;

const
	valor_alto = 9999;
	
type 
	reg_producto = record
		codigo: integer;
		nombre: string[20];
		precio: real;
		stock_act: integer;
		stock_min: integer;
	end;
	
	reg_venta = record
		codigo: integer;
		cantidad: integer;
	end;
	
	archivo_productos = file of reg_producto;
	archivo_ventas = file of reg_venta;

procedure leer (var detalle: archivo_ventas; var venta: reg_venta);
begin
	if not EOF(detalle) then read(detalle, venta)
	else
		venta.codigo:= valor_alto;
end;

procedure crearArchivos (var productos: archivo_productos; var detalle: archivo_ventas);
var
	producto: reg_producto; venta: reg_venta;
	
begin
	rewrite(productos);
	rewrite(detalle);
	
	producto.codigo:= 1;
	producto.nombre:= 'Leche';
	producto.precio:= 1550;
	producto.stock_act:= 20;
	producto.stock_min:= 50;
	write(productos, producto);
	
	producto.codigo:= 2;
	producto.nombre:= 'Queso';
	producto.precio:= 3489;
	producto.stock_act:= 60;
	producto.stock_min:= 50;
	write(productos, producto);
	
	producto.codigo:= 3;
	producto.nombre:= 'Harina';
	producto.precio:= 850;
	producto.stock_act:= 30;
	producto.stock_min:= 50;
	write(productos, producto);
	
	producto.codigo:= 4;
	producto.nombre:= 'Papel de Cocina';
	producto.precio:= 2378;
	producto.stock_act:= 15;
	producto.stock_min:= 50;
	write(productos, producto);
	
	producto.codigo:= 5;
	producto.nombre:= 'Huevos';
	producto.precio:= 2360;
	producto.stock_act:= 45;
	producto.stock_min:= 50;
	write(productos, producto);
	
	venta.codigo:= 1;
	venta.cantidad:= 2;
	write(detalle, venta);
	venta.codigo:= 1;
	venta.cantidad:= 3;
	write(detalle, venta);
	
	venta.codigo:= 3;
	venta.cantidad:= 2;
	write(detalle, venta);
	venta.codigo:= 3;
	venta.cantidad:= 2;
	write(detalle, venta);
	venta.codigo:= 3;
	venta.cantidad:= 6;
	write(detalle, venta);
	
	venta.codigo:= 4;
	venta.cantidad:= 3;
	write(detalle, venta);
	venta.codigo:= 4;
	venta.cantidad:= 1;
	write(detalle, venta);
	
	venta.codigo:= 5;
	venta.cantidad:= 10;
	write(detalle, venta);
	
	close(detalle);
	close(productos);
end;

procedure actualizarMaestro (var productos: archivo_productos; var detalle: archivo_ventas);
var
	venta: reg_venta; producto: reg_producto; actual: integer;
	
begin
	reset(productos);
	reset(detalle);
	
	leer(detalle, venta);
	while (venta.codigo <> valor_alto) do begin
		read(productos, producto);
		while (producto.codigo <> venta.codigo) do begin
			read(productos, producto);
		end;
		actual:= venta.codigo;
		while (actual = venta.codigo) do begin
			producto.stock_act:= producto.stock_act - venta.cantidad;
			leer(detalle, venta);
		end;
		seek(productos, filePos(productos) - 1);
		write(productos, producto);
	end;
	
	writeln(#10, 'Archivo maestro actualizado con exito.', #10);

	close(productos);
	close(detalle);
end;

procedure listarTexto (var productos: archivo_productos);
var
	txt: text; producto: reg_producto;
	
begin
	assign(txt, 'stock_minimo.txt');
	rewrite(txt);
	reset(productos);
	
	while not EOF(productos) do begin
		read(productos, producto);
		if (producto.stock_act < producto.stock_min) then
			writeln(txt, 'Codigo: ', producto.codigo, ' Nombre: ', producto.nombre, ' Precio: ', producto.precio:5:2, ' Stock actual: ', producto.stock_act, ' Stock minimo: ', producto.stock_min);
	end;
	
	writeln(#10, 'Listado creado con exito.', #10);
	close(txt);
	close(productos);
end;

var
	productos: archivo_productos; detalle: archivo_ventas; opcion: integer;

BEGIN
	assign(productos, 'productos');
	assign(detalle, 'detalle');
	repeat
		writeln('------- MENU -------');
		writeln('1. Crear archivos (para probarlo).');
		writeln('2. Actualizar archivo maestro.');
		writeln('3. Listar en texto los productos con stock critico.');
		writeln('4. Salir.');
		readln(opcion);
		
		case opcion of
			1: crearArchivos(productos, detalle);
			2: actualizarMaestro(productos, detalle);
			3: listarTexto(productos);
			4: writeln(#10, 'Cerrando aplicacion...');
		else writeln('Opcion invalida. Intente de nuevo.');
		end;
	until (opcion = 4);
END.

