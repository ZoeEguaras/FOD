{10. Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el
siguiente formato:

 Departamento
 División
 Número de Empleado Total de Hs. Importe a cobrar
 ......
 ......
 ..........
 ..........
 Total de horas división: ____
 Monto total por división: ____
 División
 .................
 Total horas departamento: ____
 Monto total departamento: ____
 .........
 .........

 Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.
}


program Ejercicio10;

const
	valor_alto = 9999;
	cant_categorias = 15;
	
type
	reg_empleado = record
		departamento: integer;
		division: integer;
		numero: integer;
		categoria: 1..cant_categorias;
		horas: real;
	end;
	
	archivo_empleados = file of reg_empleado;
	vector_valores = array[1..cant_categorias] of real;

procedure leer (var archivo: archivo_empleados; var reg: reg_empleado);
begin
	if not EOF(archivo) then read(archivo, reg)
	else 
		reg.departamento:= valor_alto;
end;

procedure crearArchivo (var archivo: archivo_empleados);
var
	reg: reg_empleado;
	
begin
	rewrite(archivo);
	
	reg.departamento:= 1;
	reg.division:= 10;
	reg.numero:= 100;
	reg.categoria:= 1;
	reg.horas:= 4.5;
	write(archivo, reg);
	
	reg.departamento:= 1;
	reg.division:= 10;
	reg.numero:= 101;
	reg.categoria:= 7;
	reg.horas:= 8;
	write(archivo, reg);
	
	reg.departamento:= 1;
	reg.division:= 11;
	reg.numero:= 102;
	reg.categoria:= 3;
	reg.horas:= 5;
	write(archivo, reg);
	
	reg.departamento:= 2;
	reg.division:= 10;
	reg.numero:= 103;
	reg.categoria:= 5;
	reg.horas:= 4.5;
	write(archivo, reg);
	
	reg.departamento:= 2;
	reg.division:= 11;
	reg.numero:= 104;
	reg.categoria:= 3;
	reg.horas:= 8.5;
	write(archivo, reg);
	
	reg.departamento:= 2;
	reg.division:= 12;
	reg.numero:= 105;
	reg.categoria:= 8;
	reg.horas:= 7;
	write(archivo, reg);
	
	reg.departamento:= 2;
	reg.division:= 12;
	reg.numero:= 106;
	reg.categoria:= 11;
	reg.horas:= 2;
	write(archivo, reg);
	
	reg.departamento:= 3;
	reg.division:= 30;
	reg.numero:= 107;
	reg.categoria:= 15;
	reg.horas:= 10;
	write(archivo, reg);
	
	reg.departamento:= 6;
	reg.division:= 12;
	reg.numero:= 108;
	reg.categoria:= 9;
	reg.horas:= 6;
	write(archivo, reg);
	
	reg.departamento:= 6;
	reg.division:= 12;
	reg.numero:= 109;
	reg.categoria:= 9;
	reg.horas:= 6;
	write(archivo, reg);
	
	close(archivo);
end;

procedure cargarValores (var texto: text; var valores: vector_valores);
var
	i, pos: integer; precio: real;
	
begin
	reset(texto);
	
	for i:= 1 to 15 do begin
		readln(texto, pos, precio);
		valores[pos]:= precio;
	end;
	
	close(texto);
end;

procedure imprimirDatos (var archivo: archivo_empleados; valores: vector_valores);
var
	reg: reg_empleado; departamento, division: integer;
	total_division, total_departamento, horas_division, horas_departamento, cobro: real;
	
begin
	reset(archivo);
	
	leer(archivo, reg);
	while (reg.departamento <> valor_alto) do begin
		departamento:= reg.departamento;
		total_departamento:= 0;
		horas_departamento:= 0;
		writeln;
		writeln('-------------- DEPARTAMENTO ', departamento, ' --------------');
		writeln;
		while (reg.departamento = departamento) do begin
			division:= reg.division;
			total_division:= 0;
			horas_division:= 0;
			writeln('Division ', division, ':');
			while (reg.departamento = departamento) and (reg.division = division) do begin
				cobro:= reg.horas * valores[reg.categoria];
				total_division:= total_division + cobro;
				horas_division:= horas_division + reg.horas;
				writeln('  Numero de Empleado: ', reg.numero, ' - Total de horas: ', reg.horas:8:2, ' - Importe a Cobrar: ', cobro:8:2);
				leer(archivo, reg);
			end;
			total_departamento:= total_departamento + total_division;
			horas_departamento:= horas_departamento + horas_division;
			writeln('Total de horas division: ', horas_division:8:2);
			writeln('Monto total por division: ', total_division:8:2);
			writeln;
		end;
		writeln;
		writeln('Total de horas departamento: ', horas_departamento:8:2);
		writeln('Monto total departamento: ', total_departamento:8:2);
		writeln;
	end;
	
	close(archivo);
end;

var
	texto: text; archivo: archivo_empleados; valores: vector_valores; nombre_fisico: string;
	
BEGIN
	assign(archivo, 'Registro - Empleados');
	
	// Creo el archivo para probar el programa
	crearArchivo(archivo);
	
	writeln('Ingrese el nombre del archivo que contiene los valores: ');
	readln(nombre_fisico);
	assign(texto, nombre_fisico + '.txt');
	
	// Cargo los valores desde el archivo de texto
	cargarValores(texto, valores);
	
	
	// Imprimo los datos solicitados
	imprimirDatos(archivo, valores);
END.

