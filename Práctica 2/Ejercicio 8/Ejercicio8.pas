{ 8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.
}


program Ejercicio8;

const
	valor_alto = 9999;
	
type
	reg_cliente = record
		codigo: integer;
		nombre: string[20];
		apellido: string[20];
	end;
	
	reg_fecha = record
		ano: integer;
		mes: 1..12;
		dia: 1..31;
	end;
	
	reg_venta = record
		cliente: reg_cliente;
		fecha: reg_fecha;
		monto: real;
	end;

	archivo_empresa = file of reg_venta;

procedure leer (var archivo: archivo_empresa; var reg: reg_venta);
begin
	if not EOF(archivo) then read(archivo, reg)
	else 
		reg.cliente.codigo:= valor_alto;
end;

procedure crearMaestro (var maestro: archivo_empresa);
var
	reg: reg_venta;
	
begin
	rewrite(maestro);
	
	reg.cliente.codigo:= 1;
	reg.cliente.nombre:= 'Juan';
	reg.cliente.apellido:= 'Perez';
	reg.fecha.ano:= 2020;
	reg.fecha.mes:= 10;
	reg.fecha.dia:= 30;
	reg.monto:= 4500;
	write(maestro, reg);
	
	reg.cliente.codigo:= 1;
	reg.cliente.nombre:= 'Juan';
	reg.cliente.apellido:= 'Perez';
	reg.fecha.ano:= 2020;
	reg.fecha.mes:= 3;
	reg.fecha.dia:= 25;
	reg.monto:= 5600;
	write(maestro, reg);
	
	reg.cliente.codigo:= 1;
	reg.cliente.nombre:= 'Juan';
	reg.cliente.apellido:= 'Perez';
	reg.fecha.ano:= 2024;
	reg.fecha.mes:= 7;
	reg.fecha.dia:= 18;
	reg.monto:= 2300;
	write(maestro, reg);
	
	reg.cliente.codigo:= 2;
	reg.cliente.nombre:= 'Valentin';
	reg.cliente.apellido:= 'Nunez';
	reg.fecha.ano:= 2024;
	reg.fecha.mes:= 8;
	reg.fecha.dia:= 12;
	reg.monto:= 3600;
	write(maestro, reg);
	
	reg.cliente.codigo:= 2;
	reg.cliente.nombre:= 'Valentin';
	reg.cliente.apellido:= 'Nunez';
	reg.fecha.ano:= 2024;
	reg.fecha.mes:= 8;
	reg.fecha.dia:= 10;
	reg.monto:= 2700;
	write(maestro, reg);
	
	reg.cliente.codigo:= 2;
	reg.cliente.nombre:= 'Valentin';
	reg.cliente.apellido:= 'Nunez';
	reg.fecha.ano:= 2024;
	reg.fecha.mes:= 9;
	reg.fecha.dia:= 11;
	reg.monto:= 7820;
	write(maestro, reg);
	
	reg.cliente.codigo:= 4;
	reg.cliente.nombre:= 'Zoe';
	reg.cliente.apellido:= 'Eguaras';
	reg.fecha.ano:= 2024;
	reg.fecha.mes:= 1;
	reg.fecha.dia:= 25;
	reg.monto:= 3500;
	write(maestro, reg);
	
	close(maestro);
end;

procedure imprimirReporte (var maestro: archivo_empresa);
var
	reg: reg_venta; total_empresa, total_anual, total_mensual: real;
	ano: integer; cliente: reg_cliente; mes: 1..12;
	
begin
	reset(maestro);
	
	writeln('----------------------- EMPRESA -----------------------');
	writeln;
	leer(maestro, reg);
	total_empresa:= 0;
	while (reg.cliente.codigo <> valor_alto) do begin
		cliente:= reg.cliente;
		writeln('---------------- CLIENTE ----------------');
		writeln('Codigo: ', reg.cliente.codigo);
		writeln('Nombre: ', reg.cliente.nombre);
		writeln('Apellido: ', reg.cliente.apellido);
		writeln;
		while (reg.cliente.codigo = cliente.codigo) do begin
			total_anual:= 0;
			ano:= reg.fecha.ano;
			writeln(' YEAR ', ano, ':');
			writeln;
			while (reg.cliente.codigo = cliente.codigo) and (ano = reg.fecha.ano) do begin
				total_mensual:= 0;
				mes:= reg.fecha.mes;
				while (reg.cliente.codigo = cliente.codigo) and (ano = reg.fecha.ano) and (mes = reg.fecha.mes) do begin
					total_mensual:= total_mensual + reg.monto;
					leer(maestro, reg);
				end;
				total_anual:= total_anual + total_mensual;
				writeln('   MES ', mes, ' - Monto Mensual: ', total_mensual:10:2);
				writeln;	
			end;
			writeln(' + Monto Anual: ', total_anual:10:2);
			writeln;
		end;
		writeln('-----------------------------------------');
		writeln;
		total_empresa:= total_empresa + total_anual;
	end;
	writeln('Monto Total: ', total_empresa:10:2);
	writeln;
	
	close(maestro);
end;

var
	maestro: archivo_empresa;

BEGIN
	assign(maestro, 'Registros - Empresa');
	
	// Creo el archivo maestro para probar el programa.
	crearMaestro(maestro);
	
	// Imprimo el reporte
	imprimirReporte(maestro);
END.

