{ 5. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}


program Ejercicio52;

const
	valor_alto = 9999;
	dimF = 30;

type
	reg_producto = record
		codigo: integer;
		nombre: string[20];
		descripcion: string[200];
		stock_disp: integer;
		stock_min: integer;
		precio: real;
	end;
	
	venta = record
		codigo: integer;
		cantidad: integer;
	end;
	
	archivo_productos = file of reg_producto;
	archivo_ventas = file of venta;
	vector_ventas = array [1..dimF] of archivo_ventas;
	reg_ventas = array [1..dimF] of venta;

procedure leer (var ventas: archivo_ventas; var venta: venta);
begin
	if not EOF(ventas) then read(ventas, venta)
	else
		venta.codigo:= valor_alto;
end;

procedure minimo (var detalles: vector_ventas; var min: venta; var reg_d: reg_ventas);
var
	i, pos: integer;
	
begin
	min.codigo:= valor_alto;
	for i:= 1 to dimF do begin
		if (reg_d[i].codigo < min.codigo) then begin
			min:= reg_d[i];
			pos:= i;
		end;
	end;
	leer(detalles[pos], reg_d[pos]);
end;

procedure crearDetalle (var detalle: archivo_ventas);
var
	v: venta;
	
begin
	rewrite(detalle);
	
	v.codigo:= 1;
	v.cantidad:= 10;
	write(detalle, v);
	
	v.codigo:= 3;
	v.cantidad:= 5;
	write(detalle, v);
	
	v.codigo:= 3;
	v.cantidad:= 2;
	write(detalle, v);
	
	close(detalle);
end;

procedure crearArchivos (var productos: archivo_productos; var detalles: vector_ventas);
var
	i: integer; prod: reg_producto;
	
begin
	rewrite(productos);
	
	prod.codigo:= 1;
	prod.nombre:= 'Leche';
	prod.descripcion:= 'Descremada y sin agregados.';
	prod.stock_disp:= 310;
	prod.stock_min:= 50;
	prod.precio:= 1850;
	write(productos, prod);
	
	prod.codigo:= 2;
	prod.nombre:= 'Huevos';
	prod.descripcion:= 'Directos de la granja.';
	prod.stock_disp:= 200;
	prod.stock_min:= 50;
	prod.precio:= 2000;
	write(productos, prod);
	
	prod.codigo:= 3;
	prod.nombre:= 'Harina';
	prod.descripcion:= 'Triple cero, con TACC.';
	prod.stock_disp:= 250;
	prod.stock_min:= 50;
	prod.precio:= 950;
	write(productos, prod);
	
	for i:= 1 to dimF do begin
		crearDetalle(detalles[i]);
	end;
	
	close(productos);
end;

procedure actualizarMaestro (var productos: archivo_productos; var detalles: vector_ventas);
var
	i: integer; reg_d: reg_ventas; min: venta; prod: reg_producto; txt: text; nombre_fisico: string;
	
begin
	writeln('Ingrese el nombre del nuevo archivo de texto: ');
	readln(nombre_fisico);
	assign(txt, nombre_fisico+'.txt');
	reset(productos);
	rewrite(txt);
	for i:= 1 to dimF do begin
		reset(detalles[i]);
	end;
	
	for i:= 1 to dimF do begin
		leer(detalles[i], reg_d[i]);
	end;
	minimo(detalles, min, reg_d);
	while (min.codigo <> valor_alto) do begin
		read(productos, prod);
		while (prod.codigo <> min.codigo) do begin
			if (prod.stock_disp < prod.stock_min) then
				writeln(txt, 'Nombre: ', prod.nombre, ' Descripcion: ', prod.descripcion, ' Stock disponible: ', prod.stock_disp, ' Precio: ', prod.precio:5:2);
			read(productos, prod);
		end;
		while (prod.codigo = min.codigo) do begin
			prod.stock_disp:= prod.stock_disp - min.cantidad;
			minimo(detalles, min, reg_d);
		end;
		if (prod.stock_disp < prod.stock_min) then
			writeln(txt, 'Nombre: ', prod.nombre, ' Descripcion: ', prod.descripcion, ' Stock disponible: ', prod.stock_disp, ' Precio: ', prod.precio:5:2);
		seek(productos, filePos(productos) - 1);
		write(productos, prod);
	end;
	
	writeln(#10, 'Archivo Maestro actualizado y archivo de texto creado con exito.', #10);
	close(productos);
	for i:= 1 to dimF do begin
		close(detalles[i]);
	end;
	close(txt);
end;

var
	productos: archivo_productos; detalles: vector_ventas;

BEGIN
	assign(productos, 'productos');
	assign(detalles[1], 'detalle1');
	assign(detalles[2], 'detalle2');
	assign(detalles[3], 'detalle3');
	assign(detalles[4], 'detalle4');
	assign(detalles[5], 'detalle5');
	assign(detalles[6], 'detalle6');
	assign(detalles[7], 'detalle7');
	assign(detalles[8], 'detalle8');
	assign(detalles[9], 'detalle9');
	assign(detalles[10], 'detalle10');
	assign(detalles[11], 'detalle11');
	assign(detalles[12], 'detalle12');
	assign(detalles[13], 'detalle13');
	assign(detalles[14], 'detalle14');
	assign(detalles[15], 'detalle15');
	assign(detalles[16], 'detalle16');
	assign(detalles[17], 'detalle17');
	assign(detalles[18], 'detalle18');
	assign(detalles[19], 'detalle19');
	assign(detalles[20], 'detalle20');
	assign(detalles[21], 'detalle21');
	assign(detalles[22], 'detalle22');
	assign(detalles[23], 'detalle23');
	assign(detalles[24], 'detalle24');
	assign(detalles[25], 'detalle25');
	assign(detalles[26], 'detalle26');
	assign(detalles[27], 'detalle27');
	assign(detalles[28], 'detalle28');
	assign(detalles[29], 'detalle29');
	assign(detalles[30], 'detalle30');
	
	// Los creo para probarlos (el chequeo no lo hago porque está en el otro).
	crearArchivos(productos, detalles);
	actualizarMaestro(productos, detalles);
END.

